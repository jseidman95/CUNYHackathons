//
//  DateEnum.swift
//  CUNYHackathons
//
//  Created by Jesse Seidman on 12/3/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import Foundation

/*
 * This enum contains the information for processing date strings
 */
enum DateEnum:String
{
    case JAN = "01"
    case FEB = "02"
    case MAR = "03"
    case APR = "04"
    case MAY = "05"
    case JUN = "06"
    case JUL = "07"
    case AUG = "08"
    case SEP = "09"
    case OCT = "10"
    case NOV = "11"
    case DEC = "12"
    
    public static func getDateFromString(dateString:String) -> String
    {
        switch(dateString)
        {
            case "Jan":
                return "01"
            case "Feb":
                return "02"
            case "Mar":
                return "03"
            case "Apr":
                return "04"
            case "May":
                return "05"
            case "Jun":
                return "06"
            case "Jul":
                return"07"
            case "Aug":
                return "08"
            case "Sep":
                return "09"
            case "Oct":
                return"10"
            case "Nov":
                return "11"
            case "Dec":
                return "12"
            default:
                return "error"
        }
    }
    
    public static func getNameFromNumber(_ dateNumString:String) -> String
    {
        switch (dateNumString)
        {
            case "01":
                return "January"
            case "02":
                return "February"
            case "03":
                return "March"
            case "04":
                return "April"
            case "05":
                return "May"
            case "06":
                return "June"
            case "07":
                return "July"
            case "08":
                return "August"
            case "09":
                return "September"
            case "10":
                return "October"
            case "11":
                return "November"
            case "12":
                return "December"
            default:
                return "Error"
        }
    }
}
