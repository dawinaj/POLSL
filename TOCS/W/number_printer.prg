
PrinterStart:
    POB prtSttNeg
    SOZ PrinterPrintNumber
    POB prtInput
    SOM PrinterDealWithNegative
    SOB PrinterPrintNumber
PrinterDealWithNegative:
    POB minusChr
    OUT 2
    POB prtInput
    ODE prtInput
    ODE prtInput
    LAD prtInput
PrinterPrintNumber:
    POB one
    LAD prtCanSkip
    LAD prtIter1
    POB prtInput
    LAD prtTemp
    PrinterCountBitsLoop:
        POB prtTemp
        SOZ PrinterBitsToDecimals
        DZI two
        LAD prtTemp
        POB prtIter1
        DOD one
        LAD prtIter1
        SOB PrinterCountBitsLoop
PrinterBitsToDecimals:
    POB prtIter1
    MNO prtLog2
    DZI prtLog10
    LAD prtIter1
    PrinterDigitLoop:
        POB prtInput
        LAD prtTemp
        POB prtIter1
        LAD prtIter2
        PrinterDivLoop:
            POB prtIter2
            SOZ PrinterDivExit
            ODE one
            LAD prtIter2
            POB prtTemp
            DZI ten
            LAD prtTemp
            SOB PrinterDivLoop
    PrinterDivExit:
        POB prtIter1
        SOZ PrinterPrintChar
        POB prtCanSkip
        SOZ PrinterPrintChar
        POB prtTemp
        SOZ PrinterSkipChar
    PrinterPrintChar:
        POB zero
        LAD prtCanSkip
        POB prtTemp
        DOD DgtDiff
        OUT 2
    PrinterSkipChar:
        POB prtIter1
        LAD prtIter2
        PrinterMulLoop:
            POB prtIter2
            SOZ PrinterMulExit
            ODE one
            LAD prtIter2
            POB prtTemp
            MNO ten
            LAD prtTemp
            SOB PrinterMulLoop
    PrinterMulExit:
        POB prtInput
        ODE prtTemp
        LAD prtInput
        POB prtIter1
        SOZ PrinterFinished
        ODE one
        LAD prtIter1
        SOB PrinterDigitLoop
PrinterFinished:
    SOB end

end:
    POB enterChr
    OUT 2
    STP


// printer input
prtInput:   RST 0

// universal constants
zero:       RST 0
one:        RST 1
two:        RST 2
ten:        RST 10
DgtDiff:    RST 48
minusChr:   RST 45
enterChr:   RST 13

//printer constants
prtLog2:    RST 28
prtLog10:   RST 93 //log(2)/log(10) ~= 28/93 [err=+0.015%]

// printer settings
prtSttNeg:  RST 0

// printer variables
prtCanSkip: RST 0
prtTemp:    RST 0
prtIter1:   RST 0
prtIter2:   RST 0
