//
//  StateEnum.swift
//  CUNYHackathons
//
//  Created by Jesse Seidman on 12/2/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import Foundation
import UIKit

/*
 * This enum contains the information for processing state strings
 */
enum StateEnum: Int
{
    case NY = 1
    case NJ
    case CT
    case PA
    case MA
    case DC
    case RI
    case MD
    case DE
    case VT
    case NH
    case ME
    case WV
    case VA
    case OH
    case MI
    case NC
    case KY
    case IN
    case SC
    case TN
    case IL
    case WI
    case GA
    case AL
    case FL
    case MS
    case LA
    case MO
    case IA
    case MN
    case AR
    case TX
    case OK
    case KS
    case NE
    case SD
    case ND
    case MT
    case WY
    case CO
    case NM
    case ID
    case UT
    case AZ
    case NV
    case WA
    case OR
    case CA
    case AK
    case HI
    
    //Cananadian data
    case ON
    case QC
    case NL
    case PE
    case NS
    case NB
    case MB
    case SK
    case AB
    case BC
    case YT
    case NT
    case CAN
    
    //Mexico data
    case MX
    
    //UK data
    case UK
    
    //unknown
    case UNK
    
    var color: UIColor
    {
        switch self
        {
            case .NY:
                return UIColor(red: 0/255.0, green: 100/255.0, blue: 0/255.0, alpha: 1.0)
            case .NJ:
                return UIColor(red: 0/255.0, green: 128/255.0, blue: 0.0/255.0, alpha: 1.0)
            case .CT:
                return UIColor(red: 46/255.0, green: 139/255.0, blue: 87/255.0, alpha: 1.0)
            case .PA:
                return UIColor(red: 60/255.0, green: 179/255.0, blue: 113/255.0, alpha: 1.0)
            case .MA:
                return UIColor(red: 144/255.0, green: 238/255.0, blue: 144/255.0, alpha: 1.0)
            case .RI:
                return UIColor(red: 0/255.0, green: 255/255.0, blue: 127/255.0, alpha: 1.0)
            case .MD:
                return UIColor(red: 50/255.0, green: 205/255.0, blue: 50/255.0, alpha: 1.0)
            case .DC:
                return UIColor(red: 50/255.0, green: 205/255.0, blue: 50/255.0, alpha: 1.0)
            
            case .DE:
                return UIColor(red: 25/255.0, green: 25/255.0, blue: 112/255.0, alpha: 1.0)
            case .VT:
                return UIColor(red: 0/255.0, green: 0/255.0, blue: 139/255.0, alpha: 1.0)
            case .NH:
                return UIColor(red: 0/255.0, green: 0/255.0, blue: 205/255.0, alpha: 1.0)
            case .ME:
                return UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
            case .WV:
                return UIColor(red: 65/255.0, green: 105/255.0, blue: 225/255.0, alpha: 1.0)
            case .VA:
                return UIColor(red: 100/255.0, green: 149/255.0, blue: 237/255.0, alpha: 1.0)
            case .OH:
                return UIColor(red: 0/255.0, green: 191/255.0, blue: 255/255.0, alpha: 1.0)
            case .MI:
                return UIColor(red: 135/255.0, green: 206/255.0, blue: 250/255.0, alpha: 1.0)
            case .NC:
                return UIColor(red: 240/255.0, green: 248/255.0, blue: 255/255.0, alpha: 1.0)
            case .KY:
                return UIColor(red: 75/255.0, green: 0/255.0, blue: 130/255.0, alpha: 1.0)
            case .IN:
                return UIColor(red: 153/255.0, green: 50/255.0, blue: 204/255.0, alpha: 1.0)
            case .SC:
                return UIColor(red: 148/255.0, green: 0/255.0, blue: 211/255.0, alpha: 1.0)
            case .TN:
                return UIColor(red: 138/255.0, green: 43/255.0, blue: 226/255.0, alpha: 1.0)
            case .IL:
                return UIColor(red: 186/255.0, green: 85/255.0, blue: 211/255.0, alpha: 1.0)
            case .WI:
                return UIColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1.0)
            case .GA:
                return UIColor(red: 218/255.0, green: 112/255.0, blue: 214/255.0, alpha: 1.0)
            case .AL:
                return UIColor(red: 238/255.0, green: 130/255.0, blue: 238/255.0, alpha: 1.0)
            case .FL:
                return UIColor(red: 221/255.0, green: 160/255.0, blue: 221/255.0, alpha: 1.0)
            case .MS:
                return UIColor(red: 216/255.0, green: 191/255.0, blue: 216/255.0, alpha: 1.0)
            
            //CHANGE COLORS
            case .LA:
                return UIColor(red: 128/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            case .MO:
                return UIColor(red: 128/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            case .IA:
                return UIColor(red: 128/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            case .MN:
                return UIColor(red: 128/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            case .AR:
                return UIColor(red: 139/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            case .TX:
                 return UIColor(red: 139/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            case .OK:
                 return UIColor(red: 139/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            case .KS:
                 return UIColor(red: 139/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            case .NE:
                return UIColor(red: 139/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            case .SD:
                 return UIColor(red: 139/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            case .ND:
                 return UIColor(red: 139/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            
            case .MT:
                return UIColor(red: 199/255.0, green: 21/255.0, blue: 133/255.0, alpha: 1.0)
            case .WY:
                return UIColor(red: 219/255.0, green: 112/255.0, blue: 147/255.0, alpha: 1.0)
            case .CO:
                return UIColor(red: 255/255.0, green: 20/255.0, blue: 147/255.0, alpha: 1.0)
            case .NM:
                return UIColor(red: 255/255.0, green: 105/255.0, blue: 180/255.0, alpha: 1.0)
            case .ID:
                return UIColor(red: 160/255.0, green: 82/255.0, blue: 45/255.0, alpha: 1.0)
            case .UT:
                return UIColor(red: 139/255.0, green: 69/255.0, blue: 19/255.0, alpha: 1.0)
            case .AZ:
                return UIColor(red: 210/255.0, green: 105/255.0, blue: 30/255.0, alpha: 1.0)
            case .NV:
                return UIColor(red: 205/255.0, green: 133/255.0, blue: 63/255.0, alpha: 1.0)
            case .WA:
                return UIColor(red: 255/255.0, green: 140/255.0, blue: 0/255.0, alpha: 1.0)
            case .OR:
                return UIColor(red: 255/255.0, green: 165/255.0, blue: 0/255.0, alpha: 1.0)
            case .CA:
                return UIColor(red: 255/255.0, green: 140/255.0, blue: 0/255.0, alpha: 1.0)
            case .AK:
                return UIColor(red: 255/255.0, green: 140/255.0, blue: 0/255.0, alpha: 1.0)
            case .HI:
                return UIColor(red: 255/255.0, green: 140/255.0, blue: 0/255.0, alpha: 1.0)
            
            //Cananadian data
            case .ON:
                return UIColor(red: 250/255.0, green: 128/255.0, blue: 114/255.0, alpha: 1.0)
            case .QC:
                return UIColor(red: 205/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1.0)
            case .NL:
                return UIColor(red: 220/255.0, green: 20/255.0, blue: 60/255.0, alpha: 1.0)
            case .PE:
                return UIColor(red: 178/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1.0)
            case .NS:
                return UIColor(red: 139/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            case .NB:
                return UIColor(red: 128/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            case .MB:
                return UIColor(red: 255/255.0, green: 99/255.0, blue: 71/255.0, alpha: 1.0)
            case .SK:
                return UIColor(red: 255/255.0, green: 69/255.0, blue: 0/255.0, alpha: 1.0)
            case .AB:
                return UIColor(red: 219/255.0, green: 112/255.0, blue: 147/255.0, alpha: 1.0)
            case .BC:
                return UIColor(red: 233/255.0, green: 150/255.0, blue: 122/255.0, alpha: 1.0)
            case .YT:
                return UIColor(red: 255/255.0, green: 160/255.0, blue: 122/255.0, alpha: 1.0)
            case .NT:
                return UIColor(red: 255/255.0, green: 69/255.0, blue: 0/255.0, alpha: 1.0)
            case .CAN:
                return UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            
            //Mexico data
            case .MX:
                return UIColor(red: 0/255.0, green: 104/255.0, blue: 71/255.0, alpha: 1.0)
            
            //UK data
            case .UK:
                return UIColor(red: 0/255.0, green: 0/255.0, blue: 102/255.0, alpha: 1.0)
            
            case .UNK:
                return UIColor(red: 0/255.0, green: 0/255.0, blue: 205/255.0, alpha: 1.0)
        }
    }
    
    static func getStateValue(stateString:String) -> StateEnum?
    {
        switch stateString
        {
            case "NY":
                return .NY
            case "NJ":
                return .NJ
            case "CT":
                return .CT
            case "PA":
                return .PA
            case "MA":
                return .MA
            case "RI":
                return .RI
            case "MD":
                return .MD
            case "DC":
                return .DC
            case "DE":
                return .DE
            case "VT":
                return .VT
            case "NH":
                return .NH
            case "ME":
                return .ME
            case "WV":
                return .WV
            case "VA":
                return .VA
            case "OH":
                return .OH
            case "MI":
                return .MI
            case "NC":
                return .NC
            case "KY":
                return .KY
            case "IN":
                return .IN
            case "SC":
                return .SC
            case "TN":
                return .TN
            case "IL":
                return .IL
            case "WI":
                return .WI
            case "GA":
                return .GA
            case "AL":
                return .AL
            case "FL":
                return .FL
            case "MS":
                return .MS
            case "LA":
                return .LA
            case "MO":
                return .MO
            case "IA":
                return .IA
            case "MN":
                return .MN
            case "AR":
                return .AR
            case "TX":
                return .TX
            case "OK":
                return .OK
            case "KS":
                return .KS
            case "NE":
                return .NE
            case "SD":
                return .SD
            case "ND":
                return .ND
            case "MT":
                return .MT
            case "WY":
                return .WY
            case "CO":
                return .CO
            case "NM":
                return .NM
            case "ID":
                return .ID
            case "UT":
                return .UT
            case "AZ":
                return .AZ
            case "NV":
                return .NV
            case "WA":
                return .WA
            case "OR":
                return .OR
            case "CA":
                return .CA
            case "AK":
                return .AK
            case "HI":
                return .HI
            
            //Cananadian data
            case "Canada":
                return .CAN
            case "Newfoundland and Labrador":
                return .NL
            case "NL":
                return .PE
            case "NS":
                return .NS
            case "NB":
                return .NB
            case "QC":
                return .QC
            case "ON":
                return .ON
            case "MB":
                return .MB
            case "SK":
                return .SK
            case "AB":
                return .AB
            case "BC":
                return .BC
            case "YT":
                return .YT
            case "NT":
                return .NT
            
            //Mexico data
            case "MX":
                return .MX
            
            //UK data
            case "UK":
                return .UK
            
            default:
                return .UNK
        }
    }
    
    static func getStateAbbreviation(stateString:String) -> String
    {
        switch stateString
        {
        case "New York":
            return "NY"
        case "New Jersey":
            return "NJ"
        case "Connecticut":
            return "CT"
        case "Pennsylvania":
            return "PA"
        case "Massachusetts":
            return "MA"
        case "Rhode Island":
            return "RI"
        case "Maryland":
            return "MD"
        case "Washington,DC":
            return "DC"
        case "Delaware":
            return "DE"
        case "Vermont":
            return "VT"
        case "Nebraska":
            return "NH"
        case "Maine":
            return "ME"
        case "West Virginia":
            return "WV"
        case "Virginia":
            return "VA"
        case "Ohio":
            return "OH"
        case "Michigan":
            return "MI"
        case "North Carolina":
            return "NC"
        case "Kentucky":
            return "KY"
        case "Indiana":
            return "IN"
        case "South Carolina":
            return "SC"
        case "Tennessee":
            return "TN"
        case "Illinois":
            return "IL"
        case "Wisconsin":
            return "WI"
        case "Georgia":
            return "GA"
        case "Alabama":
            return "AL"
        case "Florida":
            return "FL"
        case "Mississippi":
            return "MS"
        case "Louisiana":
            return "LA"
        case "Missouri":
            return "MO"
        case "Iowa":
            return "IA"
        case "Minnesota":
            return "MN"
        case "Arkansas":
            return "AR"
        case "Texas":
            return "TX"
        case "Oklahoma":
            return "OK"
        case "Kansas":
            return "KS"
        case "Nebraska":
            return "NE"
        case "South Dakota":
            return "SD"
        case "North Dakota":
            return "ND"
        case "Montanta":
            return "MT"
        case "Wyoming":
            return "WY"
        case "Colorado":
            return "CO"
        case "New Mexico":
            return "NM"
        case "Idaho":
            return "ID"
        case "Utah":
            return "UT"
        case "Arizona":
            return "AZ"
        case "Nevada":
            return "NV"
        case "Washington":
            return "WA"
        case "Oregon":
            return "OR"
        case "California":
            return "CA"
        case "Alaska":
            return "AK"
        case "Hawaii":
            return "HI"
            
        //Cananadian data
        case "Canada":
            return "CAN"
        case "Newfoundland and Labrador":
            return "NL"
        case "Prince Edward Island":
            return "PE"
        case "Nova Scotia":
            return "NS"
        case "New Brunswick":
            return "NB"
        case "Scotia":
            return "NS"
        case "Quebec":
            return "QC"
        case "Ontario":
            return "ON"
        case "Manitoba":
            return "MB"
        case "Saskatchewan":
            return "SK"
        case "Alberta":
            return "AB"
        case "British Columbia":
            return "BC"
        case "Yukon":
            return "YT"
        case "Northwest Territories":
            return "NT"
            
        //Mexico data
        case "Mexico":
            return "MX"
            
        //UK data
        case "United Kingdom":
            return "UK"
            
        default:
            return "Error"
        }
    }
}

