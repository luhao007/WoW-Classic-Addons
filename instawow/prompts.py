# pyright: reportUnusedFunction=false

from __future__ import annotations

from collections.abc import Sequence
from functools import partial
from typing import Any

from prompt_toolkit.application import Application
from prompt_toolkit.document import Document
from prompt_toolkit.key_binding import KeyBindings, KeyPressEvent
from prompt_toolkit.keys import Keys
from prompt_toolkit.styles import Style
from prompt_toolkit.validation import ValidationError, Validator
import pydantic
from questionary import Choice, confirm as _confirm, path as _path
from questionary.prompts.common import InquirerControl, Separator, create_inquirer_layout
from questionary.question import Question

from . import models


class PydanticValidator(Validator):
    "One-off validators for Pydantic model fields."

    def __init__(self, model: type[pydantic.BaseModel], field: str) -> None:
        self.model = model
        self.field = field

    def validate(self, document: Document) -> None:
        try:
            self.model.parse_obj({self.field: document.text})
        except pydantic.ValidationError as error:
            error_at_loc = next((e for e in error.errors() if e['loc'] == (self.field,)), None)
            if error_at_loc:
                raise ValidationError(0, error_at_loc['msg'])


class PkgChoice(Choice):
    def __init__(self, *args: Any, pkg: models.Pkg, **kwargs: Any) -> None:
        super().__init__(*args, **kwargs)
        self.pkg = pkg


qstyle = Style(
    [
        ('qmark', 'fg:ansicyan'),
        ('question', 'bold'),
        ('answer', 'fg: nobold'),
        ('skipped-answer', 'fg:ansiyellow'),
        ('highlight-sub', 'fg:ansimagenta'),
    ]
)

skip = Choice([('', 'skip')], ())

confirm = partial(_confirm, qmark='?', style=qstyle)
path = partial(_path, qmark='>', style=qstyle)


def checkbox(message: str, choices: Sequence[Choice], **inquirer_kwargs: Any) -> Question:
    def get_prompt_tokens():
        tokens: list[tuple[str, str]] = [('class:question', message)]
        if ic.is_answered:
            tokens.append(('class:answer', '  done'))
        else:
            tokens.append(
                (
                    'class:instruction',
                    '  (use arrow keys to move, <space> to select, <o> to view in your browser)',
                )
            )
        return tokens

    ic = InquirerControl(choices, None, use_indicator=False, use_shortcuts=False, use_pointer=True)
    bindings = KeyBindings()

    @bindings.add(Keys.ControlQ, eager=True)
    @bindings.add(Keys.ControlC, eager=True)
    def abort(event: KeyPressEvent):
        event.app.exit(exception=KeyboardInterrupt, style='class:aborting')

    @bindings.add(' ', eager=True)
    def toggle(event: KeyPressEvent):
        pointed_choice = ic.get_pointed_at().value
        if pointed_choice in ic.selected_options:
            ic.selected_options.remove(pointed_choice)
        else:
            ic.selected_options.append(pointed_choice)

    @bindings.add('i', eager=True)
    def invert(event: KeyPressEvent):
        inverted_selection = [
            c.value
            for c in ic.choices
            if not isinstance(c, Separator)
            and c.value not in ic.selected_options
            and not c.disabled
        ]
        ic.selected_options = inverted_selection

    @bindings.add(Keys.Down, eager=True)
    @bindings.add('j', eager=True)
    def move_cursor_down(event: KeyPressEvent):
        ic.select_next()
        while not ic.is_selection_valid():
            ic.select_next()

    @bindings.add(Keys.Up, eager=True)
    @bindings.add('k', eager=True)
    def move_cursor_up(event: KeyPressEvent):
        ic.select_previous()
        while not ic.is_selection_valid():
            ic.select_previous()

    @bindings.add(Keys.ControlM, eager=True)
    def set_answer(event: KeyPressEvent):
        ic.is_answered = True
        event.app.exit(result=[c.value for c in ic.get_selected_values()])

    @bindings.add('o', eager=True)
    def open_url(event: KeyPressEvent):
        choice = ic.get_pointed_at()
        if isinstance(choice, PkgChoice):
            import webbrowser

            webbrowser.open(choice.pkg.url)

    @bindings.add(Keys.Any)
    def default(event: KeyPressEvent):
        # Disallow inserting other text
        pass

    layout = create_inquirer_layout(ic, get_prompt_tokens, **inquirer_kwargs)
    return Question(Application(layout=layout, key_bindings=bindings, style=qstyle))


def select(
    message: str,
    choices: Sequence[str] | Sequence[Choice],
    initial_choice: str | Choice | None = None,
    **inquirer_kwargs: Any,
) -> Question:
    def get_prompt_tokens():
        tokens: list[tuple[str, str]] = [('class:qmark', '- '), ('class:question', message)]
        if ic.is_answered:
            answer = ic.get_pointed_at()
            title = answer.title
            assert title
            tokens.extend(
                [
                    ('', ' '),
                    (
                        'class:skipped-answer' if answer is skip else 'class:answer',
                        ''.join(t[1] for t in title) if isinstance(title, list) else title,
                    ),
                ]
            )
        return tokens

    ic = InquirerControl(
        choices,
        None,
        use_indicator=False,
        use_shortcuts=False,
        use_pointer=True,
        initial_choice=initial_choice,
    )
    bindings = KeyBindings()

    @bindings.add(Keys.ControlQ, eager=True)
    @bindings.add(Keys.ControlC, eager=True)
    def abort(event: KeyPressEvent):
        event.app.exit(exception=KeyboardInterrupt, style='class:aborting')

    @bindings.add(Keys.Down, eager=True)
    @bindings.add('j', eager=True)
    def move_cursor_down(event: KeyPressEvent):
        ic.select_next()
        while not ic.is_selection_valid():
            ic.select_next()

    @bindings.add(Keys.Up, eager=True)
    @bindings.add('k', eager=True)
    def move_cursor_up(event: KeyPressEvent):
        ic.select_previous()
        while not ic.is_selection_valid():
            ic.select_previous()

    @bindings.add(Keys.ControlM, eager=True)
    def set_answer(event: KeyPressEvent):
        ic.is_answered = True
        event.app.exit(result=ic.get_pointed_at().value)

    @bindings.add('o', eager=True)
    def open_url(event: KeyPressEvent):
        choice = ic.get_pointed_at()
        if isinstance(choice, PkgChoice):
            import webbrowser

            webbrowser.open(choice.pkg.url)

    if skip in ic.choices:

        @bindings.add('s', eager=True)
        def skip_question(event: KeyPressEvent):
            ic.pointed_at = -1
            set_answer(event)

    @bindings.add(Keys.Any)
    def default(event: KeyPressEvent):
        # Disallow inserting other text
        pass

    layout = create_inquirer_layout(ic, get_prompt_tokens, **inquirer_kwargs)
    return Question(Application(layout=layout, key_bindings=bindings, style=qstyle))
