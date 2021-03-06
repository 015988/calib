function varargout = calib(varargin)
% CALIB M-file for calib.fig
%      CALIB, by itself, creates a new CALIB or raises the existing
%      singleton*.
%
%      H = CALIB returns the handle to a new CALIB or the handle to
%      the existing singleton*.
%
%      CALIB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIB.M with the given input arguments.
%
%      CALIB('Property','Value',...) creates a new CALIB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calib_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calib_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calib

% Last Modified by GUIDE v2.5 03-Mar-2010 15:07:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calib_OpeningFcn, ...
                   'gui_OutputFcn',  @calib_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before calib is made visible.
function calib_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calib (see VARARGIN)

base=fileparts(which('calib'));
addpath([base '/etc']);
addpath([base '/lib']);


% Choose default command line output for calib
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes calib wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calib_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calibration.
function calibration_Callback(hObject, eventdata, handles)
% hObject    handle to calibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

base=fileparts(which('calib'));
addpath([base '/etc']);
addpath([base '/lib']);

dat_file=pick('dat');
if (~isempty(dat_file))
    %first calibration
    calib_clb=load_calibration(dat_file,1,1); %compute and use radial
    %saves for temporary use
    save_calibration(calib_clb,'temp_aux',1);
    %corrects the calibration points
    undistort_dat(dat_file,['corr_' dat_file],'temp_aux.clb',0);
    %removes the temporary file
    delete('temp_aux.clb');

    %linear calibration
    calib_cal=load_calibration(['corr_' dat_file],1,0); %compute linear
    
    %preparing for save
    prefix=input('Please enter the name for the clb/cal files: (without extension) ','s');
    if (~isempty(prefix))
        save_calibration(calib_clb,prefix,1);
        save_calibration(calib_cal,prefix,0);
    end
    %a little feedback :)
    disp('Done!');
end


% --- Executes on button press in undistort.
function undistort_Callback(hObject, eventdata, handles)
% hObject    handle to undistort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%choosing the original dat file
base=fileparts(which('calib'));
addpath([base '/etc']);
addpath([base '/lib']);

dat_file=pick('dat');
%naming the new dat file
new_file=input(sprintf('Please enter the desired name for the corrected dat: []=%s',['corr_' dat_file]),'s');
if (isempty(new_file))
    new_file=['corr_' dat_file];
end
%which calibration to use?
calib=pick('clb');
%undistorts the dat
undistort_dat(dat_file,new_file,calib,0);
%feedback
disp('Done!');


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[c1 c2]=load_stereo_calib(pick('.mat'));


