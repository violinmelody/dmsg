/*
        DISCORD MINESWEEPER GENERATOR
        BY VIOLIN MELODY
        http://twitter.com/violinpony
        
        MAIN GENERATION CODE
        
        03:26 25.07.2019
*/

/*
    USAGE:
        generateMS( mines, width, height, emoji, emoji2, numTiles, visible);
    
    WHERE:
        mines           -   number of mines
        width           -   number of columns
        height          -   number of rows
        emoji           -   emoji to be used as mine
        emoji2          -   emoji to be used as empty field
        numTiles        -   0=no; 1=yes; generate numbers around mines
        visible         -   are empty tiles visible?
        
    RETURNS:
        string (with all the shit needed to paste into discord UWU)
*/

//Get all parameters:
var _m = argument0;
var _w = argument1;
var _h = argument2;
var _e = argument3;
var _p = argument4;
var _n = argument5;
var _v = argument6;

//Check them out and if they aren't filled properly - randomize:
if (_m <= 0) _m = irandom(100);
if (_w <= 0) _w = irandom_range(6,10);
if (_h <= 0) _h = _w;
if (_e = "") _e = choose("boom","fire","broken_heart","hammer","skull","skull_crossbones");

if (_n) {       //make sure to draw proper empty field depending on number tiles setting (if on, draw white square, else generate whatever you want)
    if (_p = "") _p = "white_large_square";
} else {
    if (_p = "") _p = choose(choose("purple_","green_","blue_","green_","black_","yellow_","")+"heart","ok_hand","white_check_mark");
}

//prevent chaos if we have more mines than fields:
if ((_w * _h) < _m) {_m = (_w * _h) - _w;}

//Define txt things:
var _door = "||";       //always x 2 and with thing in the middle
var _space = " ";       //space between doors, we'll probably need it... I believe
var _newLine = "
";    //nothing to comment here, we go for another line... in weirdest possible way
var _sign = ":";        //emoji sign used by Discord

var _0 = "zero";
var _1 = "one";
var _2 = "two";
var _3 = "three";
var _4 = "four";
var _5 = "five";
var _6 = "six";
var _7 = "seven";
var _8 = "eight";

//Defune string output:
var _output = "";

//Define enums:
var enum FIELD_TYPE {
    empty,
    bomb,
    one,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight
}

//Prepare the playground:
var _playground = ds_grid_create(_w,_h);

//populate it:
var _tileCount = 0;
for (i=0; i<_h; i++){
    for (j=0; j<_w; j++){
        ds_grid_set(_playground, j, i, FIELD_TYPE.empty);
        _tileCount += 1;
    }
}

//plant the bombs:
for (i=0; i<_m; i++){
    var _randX = irandom(_w-1);
    var _randY = irandom(_h-1);;
    var _selTile = ds_grid_get(_playground, _randX, _randY);
    
    while(_selTile == FIELD_TYPE.bomb){                                      //in case we selected tile with bomb already placed, go somewhere else
        _randX = irandom(_w-1);
        _randY = irandom(_h-1);;
        _selTile = ds_grid_get(_playground, _randX, _randY);
    }
    
    if (_selTile != FIELD_TYPE.bomb) {                                      //the bomb has been planted!
        ds_grid_set(_playground, _randX, _randY, FIELD_TYPE.bomb);
    }
}

//set numbers of bombs near the field:
if (_n) {
    for (i=0; i<_h; i++){
        for (j=0; j<_w; j++){
        
            var _bCount = 0;                                    //check around selected field for bombs and count them
            for (k=0; k<8; k++) {
                switch (k) {
                    case 0:
                        _selTile = ds_grid_get(_playground, j-1, i-1);
                        if (_selTile = 1) {_bCount += 1;}       //we found the bomb (top left)
                        break;
                    case 1:
                        _selTile = ds_grid_get(_playground, j, i-1);
                        if (_selTile = 1) {_bCount += 1;}       //we found the bomb (top)
                        break;
                    case 2:
                        _selTile = ds_grid_get(_playground, j+1, i-1);
                        if (_selTile = 1) {_bCount += 1;}       //we found the bomb (top right)
                        break;
                    case 3:
                        _selTile = ds_grid_get(_playground, j-1, i);
                        if (_selTile = 1) {_bCount += 1;}       //we found the bomb (middle left)
                        break;
                    case 4:
                        _selTile = ds_grid_get(_playground, j+1, i);
                        if (_selTile = 1) {_bCount += 1;}       //we found the bomb (middle right)
                        break;
                    case 5:
                        _selTile = ds_grid_get(_playground, j-1, i+1);
                        if (_selTile = 1) {_bCount += 1;}       //we found the bomb (bottom left)
                        break;
                    case 6:
                        _selTile = ds_grid_get(_playground, j, i+1);
                        if (_selTile = 1) {_bCount += 1;}       //we found the bomb (bottom)
                        break;
                    case 7:
                        _selTile = ds_grid_get(_playground, j+1, i+1);
                        if (_selTile = 1) {_bCount += 1;}       //we found the bomb (bottom right)
                        break;
                    default:
                        break;
                }
            }
            //get ready to place proper number in the field depending on bomb count:
            var _number = FIELD_TYPE.empty;
            switch (_bCount) {
                case 1:
                    _number = FIELD_TYPE.one;
                    break;
                case 2:
                    _number = FIELD_TYPE.two;
                    break;
                case 3:
                    _number = FIELD_TYPE.three;
                    break;
                case 4:
                    _number = FIELD_TYPE.four;
                    break;
                case 5:
                    _number = FIELD_TYPE.five;
                    break;
                case 6:
                    _number = FIELD_TYPE.six;
                    break;
                case 7:
                    _number = FIELD_TYPE.seven;
                    break;
                case 8:
                    _number = FIELD_TYPE.eight;
                    break;
                default:
                    _number = FIELD_TYPE.empty;
                    break;
            }        
            _selTile = ds_grid_get(_playground, j, i);          //select main field we're going to set number for
            if (_selTile != FIELD_TYPE.bomb) {                  //we need to be sure it wasn't field with the bomb...
                ds_grid_set(_playground, j, i, _number);        //set number depending on the bomb count
            }    
        }
    }
}

//generate string for Discord:
var _localDoor = _door;             //you know how it is... sometimes we need to define additional variable just to not override original one - here I needed to do so for "visibe field" setting
for (i=0; i<_h; i++){
    for (j=0; j<_w; j++){
        _selTile = ds_grid_get(_playground, j, i);
        if (_selTile = 0) {_add = _p;}                                      //empty
        if (_selTile = 1) {_add = _e;}                                      //bomb
        if (_selTile = 2) {_add = _1;}                                      //1 bomb is near
        if (_selTile = 3) {_add = _2;}                                      //2 bombs are near
        if (_selTile = 4) {_add = _3;}                                      //3 bombs are near
        if (_selTile = 5) {_add = _4;}                                      //4 bombs are near
        if (_selTile = 6) {_add = _5;}                                      //5 bombs are near
        if (_selTile = 7) {_add = _6;}                                      //6 bombs are near
        if (_selTile = 8) {_add = _7;}                                      //7 bombs are near
        if (_selTile = 9) {_add = _8;}                                      //8 bombs are near
        
        if (_v ) && (_selTile = 0){ //make sure to set it visible or hide it (depending on setting, but only for empty fields)
            _localDoor = "";
        } else {
            _localDoor = _door;
        }
        
        _output += _localDoor + _sign + _add + _sign + _localDoor + _space;
    }
    _output += _newLine;
}

//clean the shit:
ds_grid_destroy(_playground);

//write values into gui fields (it's useless for generating but needed for gui):
global.value[1] = _m;
global.value[2] = _w;
global.value[3] = _h;
global.value[4] = _e;
global.value[5] = _p;
global.value[6] = _n;
global.value[7] = _v;

return _output;
