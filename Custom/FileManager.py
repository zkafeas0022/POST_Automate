# !/usr/bin/python
# -*-coding: utf-8 -*-

import codecs
import os
import shutil

import sys
reload(sys)
sys.setdefaultencoding('UTF-8')


class FileManager:

    def __init__(self):
        self.current_file = None

    @staticmethod
    def get_file_exist(path):
        return os.path.exists(path)

    @staticmethod
    def get_folder_exist(path):
        return os.path.isdir(path)

    @staticmethod
    def create_folder(path, name):
        if path != "" and name != "":
            new_folder = ""
            arr_path = path.split("\\")

            for i_path in range(0, len(arr_path)):
                if arr_path[i_path] != "":
                    new_folder = new_folder + arr_path[i_path] + "\\"

            new_folder = new_folder + name

            if not os.path.exists(new_folder):
                os.makedirs(new_folder)

            print new_folder
            return new_folder

    @staticmethod
    def create_file(path, filename, filetype, fileformat):
        fullname = path + "\\" + filename + "." + filetype
        try:
            new_file = codecs.open(fullname, "w", fileformat)
            new_file.close()
            return True
        except Exception as e:
            print e
            return False

    @staticmethod
    def write_file(filename_with_path, text, fileformat):
        try:
            text_file = codecs.open(filename_with_path, "a", fileformat)
            text_file.write(text)
            text_file.close()
            return True
        except Exception as e:
            print e
            return False

    @staticmethod
    def read_file(filename_with_path):
        try:
            text_file = open(filename_with_path, "r")
            return text_file.read()
        except Exception:
            return None

    @staticmethod
    def read_line_file(filename_with_path):
        try:
            text_file = open(filename_with_path, "r")
            return text_file.readlines()
        except Exception as e:
            print e
            return None

    @staticmethod
    def copy_file(sources, destination):
        try:
            copyfile(sources, destination)
            return True
        except Exception as e:
            print e
            return False

    @staticmethod
    def delete_file(filename_with_extension):
        try:
            os.remove(filename_with_extension)
            return True
        except Exception as e:
            print e
            return False

    @staticmethod
    def delete_all_file_in_folder(folder_path):
        for the_file in os.listdir(folder_path):
            file_path = os.path.join(folder_path, the_file)
            try:
                if os.path.isfile(file_path):
                    os.unlink(file_path)
                elif os.path.isdir(file_path):
                    shutil.rmtree(file_path)
                return True
            except Exception as e:
                print(e)
                return False

    @staticmethod
    def append_data_to_file_us_python(filename_with_path, data):
        try:
            py_file = open(filename_with_path, "a+")
            py_file.write(data)
            py_file.close()
            return True
        except Exception as e:
            print(e)
            return False
