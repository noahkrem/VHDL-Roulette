# VHDL-Roulette
A Roulette engine designed for the Altera DE2-115 FPGA board.

## Description
This program is implemented entirely in VHDL. The goal of this project is to understand the workings of a relatively large datapath circuit. The user can make three types of bets:
### Bet 1, Straight-up:
  - Amount to bet ($0-$7): Switches 2-0
  - Number to bet on (0-36): Switches 8-3
### Bet 2, Colour:
  - Amount to bet ($0-$7): Switches 9-11
  - Colour to bet on (0-1): Switch 12 [red=1, black=0]
### Bet 3, Dozen:
  - Amount to bet ($0-$7): Switches 15-13
  - Dozen to bet on (0, 1, or 2): Switches 17-16

The SpinWheel block continuously cycles through potential spin results, while the WinDetector, New_Balance, and Seg7Decoder blocks check for wins, calculate the win/loss amounts, and output them to the HEX display on the board

