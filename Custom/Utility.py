# !/usr/bin/python
# -*-coding: utf-8-*-

import xmltodict
import json
import calendar
import xml.dom.minidom
from datetime import datetime
from datetime import timedelta

import sys
reload(sys)
sys.setdefaultencoding('UTF-8')


def calculate_date_difference(date_from, date_to, date_from_format="%d-%b-%Y %H:%M:%S", date_to_format="%d-%b-%Y %H:%M:%S"):
    try:
        start_date = datetime.strptime(date_from, date_from_format)
        stop_date = datetime.strptime(date_to, date_to_format)
        diff_date = stop_date - start_date
        diff_result = divmod(diff_date.days*86400+diff_date.seconds, 60)
        return diff_result
    except Exception as e:
        raise e


def get_current_date_and_time_iso():
    return datetime.now().isoformat()[:-3]


def get_current_date_and_time_maintenance():
    return str(datetime.now()).replace(" ", "-").replace(":", ".")


def get_current_date_and_time(flag_time=True, seperate=True, flag_year="L"):
    if flag_year.strip().upper() == "L":
        year = "%Y"
    else:
        year = "%y"

    if flag_time:
        dt = datetime.now().strftime(year+'-%m-%d %H:%M:%S')
    else:
        dt = datetime.now().strftime(year+'-%m-%d')

    if seperate is not True:
        dt = dt.replace(" ", "").replace("-", "").replace(":", "")
    return dt


def get_xml_content_by_tag(str_xml, xml_tags, str_rev=None):
    list_xml = str_xml.split("<" + xml_tags + ">")
    last_xml = list_xml[1].split("</" + xml_tags + ">")
    final_xml = "<" + xml_tags + ">" + last_xml[0] + "</" + xml_tags + ">"
    if str_rev is not None:
        final_xml = final_xml.replace(str_rev, "")
    return final_xml


def convert_xml_to_dictionary(str_xml, tag_xml):
    message = """""" + str_xml + """"""
    try:
        xml_dict = xmltodict.parse(message)[tag_xml]
        return xml_dict
    except Exception as e:
        raise e


def convert_json_to_dictionary(sources_json, encoding="UTF-8"):
    dict_json = json.loads(str(sources_json).encode(encoding))
    return dict_json


def convert_json_to_string(sources_json):
    str_json = json.dumps(sources_json)
    return str_json


def convert_date_to_weekday(year, month, day):
    try:
        date = calendar.weekday(int(year), int(month), int(day))
        days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
        return days[date]
    except Exception as e:
        raise e


def compare_date_is_between_two_other_dates(date_from, date_to, date_compare, date_format="%d/%m/%Y"):
    data_date_from1 = datetime.strptime(str(date_from), date_format)
    data_date_compare = datetime.strptime(str(date_compare), date_format)
    data_date_to = datetime.strptime(str(date_to), date_format)
    data_date_from2 = datetime.strptime(str(date_from), date_format)
    delta1 = data_date_compare - data_date_from1
    delta2 = data_date_to - data_date_compare
    delta3 = data_date_from2 - data_date_from1
    if delta1.days >= delta3.days and delta2.days >= delta3.days:
        return True
    else:
        return False


def pretty_json_string(sources_json):
    try:
        sources_json = json.loads(str(sources_json))
        sources_json = str(json.dumps(sources_json, indent=4, sort_keys=True)).encode("UTF-8")
        sources_json = sources_json.decode("UTF-8")
        return sources_json
    except Exception as e:
        raise e


def pretty_xml_string(sources_xml):
    try:
        sources_xml = xml.dom.minidom.parseString(sources_xml)
        sources_xml_string = sources_xml.toprettyxml()
        return sources_xml_string
    except Exception as e:
        raise e


def adding_time_by_seconds(time, second):
    try:
        str_time = str(time)
        int_sec = int(second)
        time_val = datetime.strptime(str_time, "%H:%M:%S.%f")
        time_adding = time_val + timedelta(seconds=int_sec)
        list_time = str(time_adding).split(" ")
        return list_time[1]
    except Exception as e:
        raise e


def convert_date_format_by_user_customize(date_string, format_from, format_to):
    try:
        origin_format = datetime.strptime(date_string, format_from)
        new_format = origin_format.strftime(format_to)
        return new_format
    except Exception as e:
        raise e
