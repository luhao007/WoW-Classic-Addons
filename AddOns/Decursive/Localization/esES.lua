--[[
    This file is part of Decursive.

    Decursive (v 2.7.7.1) add-on for World of Warcraft UI
    Copyright (C) 2006-2019 John Wellesz (Decursive AT 2072productions.com) ( http://www.2072productions.com/to/decursive.php )

    Decursive is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Decursive is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Decursive.  If not, see <https://www.gnu.org/licenses/>.


    Decursive is inspired from the original "Decursive v1.9.4" by Patrick Bohnet (Quu).
    The original "Decursive 1.9.4" is in public domain ( www.quutar.com )

    Decursive is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY.

    This file was last updated on 2019-11-18T13:42:00Z
--]]
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Spanish localization
-------------------------------------------------------------------------------

--[=[
--                      YOUR ATTENTION PLEASE
--
--         !!!!!!! TRANSLATORS TRANSLATORS TRANSLATORS !!!!!!!
--
--    Thank you very much for your interest in translating Decursive.
--    Do not edit those files. Use the localization interface available at the following address:
--
--      ################################################################
--      #  http://wow.curseforge.com/projects/decursive/localization/  #
--      ################################################################
--
--    Your translations made using this interface will be automatically included in the next release.
--
--]=]

local addonName, T = ...;
-- big ugly scary fatal error message display function {{{
if not T._FatalError then
-- the beautiful error popup : {{{ -
StaticPopupDialogs["DECURSIVE_ERROR_FRAME"] = {
    text = "|cFFFF0000Decursive Error:|r\n%s",
    button1 = "OK",
    OnAccept = function()
        return false;
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    showAlert = 1,
    preferredIndex = 3,
    }; -- }}}
T._FatalError = function (TheError) StaticPopup_Show ("DECURSIVE_ERROR_FRAME", TheError); end
end
-- }}}
if not T._LoadedFiles or not T._LoadedFiles["enUS.lua"] then
    if not DecursiveInstallCorrupted then T._FatalError("Decursive installation is corrupted! (enUS.lua not loaded)"); end;
    DecursiveInstallCorrupted = true;
    return;
end
T._LoadedFiles["esES.lua"] = false;

local L = LibStub("AceLocale-3.0"):NewLocale("Decursive", "esES");

if not L then
    T._LoadedFiles["esES.lua"] = "2.7.7.1";
    return;
end;

L["ABOLISH_CHECK"] = "Comprobar \"Abolido\" antes de curar"
L["ABOUT_AUTHOREMAIL"] = "E-MAIL DEL AUTOR"
L["ABOUT_CREDITS"] = "CREDITOS"
L["ABOUT_LICENSE"] = "LICENCIA"
L["ABOUT_NOTES"] = "Visualización y limpieza de aflicciones en solitario, en grupo y en bandas con filtrado avanzado y sistema de prioridad."
L["ABOUT_OFFICIALWEBSITE"] = "PÁGINA WEB OFICIAL"
L["ABOUT_SHAREDLIBS"] = "BIBLIOTECAS COMPARTIDAS"
L["ABSENT"] = "Falta (%s)"
L["AFFLICTEDBY"] = "%s Afectado"
L["ALT"] = "Alt"
L["AMOUNT_AFFLIC"] = "Cantidad de afectados a mostrar:"
L["ANCHOR"] = "Anclaje del Texto de Decursive"
L["BINDING_NAME_DCRMUFSHOWHIDE"] = "Mostrar u ocultar los micro-marcos unidades"
L["BINDING_NAME_DCRPRADD"] = "Añadir objetivo a la lista de prioridad"
L["BINDING_NAME_DCRPRCLEAR"] = "Limpiar la lista de prioridad"
L["BINDING_NAME_DCRPRLIST"] = "Imprimir la lista de prioridad"
L["BINDING_NAME_DCRPRSHOW"] = "Mostrar u ocultar la lista de prioridad"
L["BINDING_NAME_DCRSHOW"] = "Mostrar u ocultar la barra principal de Decursive"
L["BINDING_NAME_DCRSHOWOPTION"] = "Mostrar el panel estático de opciones"
L["BINDING_NAME_DCRSKADD"] = "Agregar objetivo a la lista de omisiones"
L["BINDING_NAME_DCRSKCLEAR"] = "Borrar la lista de omisión"
L["BINDING_NAME_DCRSKLIST"] = "Imprimir la lista de omisión"
L["BINDING_NAME_DCRSKSHOW"] = "Mostrar u ocultar la lista de omisión"
L["BLACK_LENGTH"] = "Segundos en la lista negra:"
L["BLACKLISTED"] = "Lista negra"
L["CHARM"] = "Control mental"
L["CLASS_HUNTER"] = "Cazador"
L["CLEAR_PRIO"] = "B"
L["CLEAR_SKIP"] = "B"
L["COLORALERT"] = "Configure la alerta de color cuando se requiera un '% s'."
L["COLORCHRONOS"] = "Contador central"
L["COLORCHRONOS_DESC"] = "Establece el color del contador central"
L["COLORSTATUS"] = "Establecer el color para el estado MUF '% s'."
L["CTRL"] = "Ctrl"
L["CURE_PETS"] = "Escanear y curar mascotas"
L["CURSE"] = "Maldición"
L["DEBUG_REPORT_HEADER"] = "|cFF11FF33Envíe por correo electrónico el contenido de esta ventana a <%s>|r |cFF009999(Usa CTRL+A para seleccionar todo y luego CTRL+C para poner el texto en su portapapeles)|r También indique en su informe si notó algún comportamiento extraño de %s."
L["DECURSIVE_DEBUG_REPORT"] = "**** |cFFFF0000Informe de Depuración Decursive|r ****"
L["DEFAULT_MACROKEY"] = "NONE"
L["DISEASE"] = "Enfermedad"
L["GLOR1"] = "En memoria de Glorfindal"
L["GLOR2"] = "Decursive está dedicado a la memoria de Bertrand, que se fue demasiado pronto. Él siempre será recordado."
L["GLOR3"] = "En recuerdo de Bertrand Sense 1969-2007"
L["GLOR4"] = "La amistad y el afecto pueden echar raíces en cualquier lugar, quienes conocieron a Glorfindal en World of Warcraft conocieron a un hombre de gran compromiso y un líder carismático. Estaba en la vida como en el juego, desinteresado, generoso, dedicado a sus amigos y, sobre todo, un hombre apasionado. Nos dejó a los 38 años dejando atrás no solo a jugadores anónimos en un mundo virtual sino a un grupo de verdaderos amigos que lo extrañarán para siempre."
L["GLOR5"] = "Él siempre será recordado..."
L["HIDE_MAIN"] = "Ocultar ventana Decursive"
L["MAGIC"] = "Magia"
L["OPT_ABOUT"] = "Acerca de"
L["OPT_UNITPERLINES_DESC"] = "Define el número máximo de micro-marcos de unidades a mostrar por línea"
L["OPT_XSPACING"] = "Espaciado horizontal"
L["OPT_YSPACING"] = "Espaciado vertical"
L["PLAY_SOUND"] = "Reproducir un sonido cuando hay alguien a quien curar"
L["POISON"] = "Veneno"
L["POPULATE"] = "p"
L["PRINT_CHATFRAME"] = "Mostrar mensajes en el chat predeterminado"
L["RANDOM_ORDER"] = "Curar en orden aleatorio"
L["SCAN_LENGTH"] = "Segundos entre escaneos en vivo :"
L["SHIFT"] = "Shift"
L["SHOW_MSG"] = "Para mostrar la ventana de Decursive, escribe /dcrshow"
L["SKIP_SHOW"] = "S"
L["SPELL_FOUND"] = "¡%s hechizo encontrado!"
L["STR_CLOSE"] = "Cerrar"
L["STR_DCR_PRIO"] = "Prioridad decursive"
L["STR_DCR_SKIP"] = "No decursear"
L["STR_GROUP"] = "Grupo"
L["STR_OPTIONS"] = "Opciones"
L["STR_OTHER"] = "Otro"
L["TOOFAR"] = "Muy lejos"



T._LoadedFiles["esES.lua"] = "2.7.7.1";
