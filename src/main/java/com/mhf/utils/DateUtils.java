package com.mhf.utils;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.util.Date;

/**
 * 时间格式转换
 */
public class DateUtils {

    private static final String STANDARD_FORMAT="yyyy-MM-dd HH:mm:ss";

    /**
     * date -> string
     */

    public static String dateToStr(Date date){
        if (date == null){
            return null;
        }
        DateTime dateTime = new DateTime(date);

        return dateTime.toString(STANDARD_FORMAT);
    }

    public static String dateToStr(Date date,String formate){
        DateTime dateTime = new DateTime(date);

        return dateTime.toString(formate);
    }

    /**
     * String -> date
     */

    public static Date strToDate(String str){
        if (str == null){
            return null;
        }
        DateTimeFormatter dateTimeFormatter = DateTimeFormat.forPattern(STANDARD_FORMAT);
        DateTime dateTime = dateTimeFormatter.parseDateTime(str);
        return dateTime.toDate();
    }

    public static Date strToDate(String str,String formate){
        DateTimeFormatter dateTimeFormatter = DateTimeFormat.forPattern(formate);
        DateTime dateTime = dateTimeFormatter.parseDateTime(str);
        return dateTime.toDate();
    }

}
