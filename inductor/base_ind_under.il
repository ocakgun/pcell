/*  TYLEE PCELL
    Copyright (C) 2013  Tao-Yi Lee (tylee@ieee.org)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


strCellName="base_ind_under";	The Cell Name is called RFVLSI_N65
strViewName="layout";	This is a virtuoso layout

pcDefinePCell(
list(ddGetObj(strLibName),strCellName, "layout"),
(
	(W	"float"	4.0)	; Line width
	(WX	"float"	4.0)	; Line width
	(S	"float"	2.0) ; Line spacing
	(TOP_ME	"int" 9)
    (BTM_ME	"int" 8)
    (NT	"int" 3)
	(INDDMY       "string" "RFVLSI")
        (INDDMYP      "string" "drawing")
        (dummy      "boolean" t)
)

let((P pi dmy techfile_lib techFileID TOP_ME_CHOSEN BTM_ME_CHOSEN),

	techfile_lib = techGetTechLibName(pcCellView~>lib)
        masterv = dbOpenCellViewByType(pcCellView~>lib "vias" "layout")
	techFileID = techGetTechFile(ddGetObj(techfile_lib))
	
	if(BTM_ME==TOP_ME
	then
		BTM_ME_CHOSEN = TOP_ME-1
		TOP_ME_CHOSEN = TOP_ME
	else
		BTM_ME_CHOSEN = BTM_ME
		TOP_ME_CHOSEN = TOP_ME-1
	)
	P=W+S; Line pitch: width + space
	/*	draw bridge	*/	
	 dbCreateParamInst(
            pcCellView masterv nil 0:-W "R0" 1
            list(
                list("Length"  "float" (W+NT*P))
                list("Width"    "float" WX)
                list("TOP_ME"   "int"   TOP_ME_CHOSEN)
                list("BTM_ME"   "int"   BTM_ME)
        )) ; close list

;	dbCreateRect(pcCellView, MetalVec(BTM_ME_CHOSEN-1),list(0:-W WX:NT*P))	 
	/*      draw bridge (end)	*/

         dbCreateParamInst(
	        pcCellView masterv nil 0:NT*P-W "R0" 1
	        list(
                list("Length"  "float" W)
                list("Width"    "float" WX)
                list("TOP_ME"   "int"   TOP_ME)
                list("BTM_ME"   "int"   TOP_ME_CHOSEN)
        ) ; close list
        ) ; close dbCreateParamInst
         dbCreateParamInst(pcCellView masterv nil 0:-W "R0" 1
        list(
                list("Length"  "float" W)
                list("Width"    "float" WX)
                list("TOP_ME"   "int"   TOP_ME)
                list("BTM_ME"   "int"   TOP_ME_CHOSEN)
        ) ; close list
        ) ; close dbCreateParamInst


if(dummy
then
	dbCreateRect(pcCellView, list(INDDMY,INDDMYP),list(0:-W WX:NT*P-W))
	for(m (BTM_ME_CHOSEN-1) (TOP_ME-1)
		dbCreateRect(pcCellView, RFVLSI_LVS_Vec(m),list(0:-W WX:NT*P-W))
	)
)
)/*end of let*/
)/*end of pcDefinePCell*/

