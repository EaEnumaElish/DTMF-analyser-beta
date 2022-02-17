function varargout = gg(varargin)
% GG MATLAB code for gg.fig
%      GG, by itself, creates a new GG or raises the existing
%      singleton*.
%
%      H = GG returns the handle to a new GG or the handle to
%      the existing singleton*.
%
%      GG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GG.M with the given input arguments.
%
%      GG('Property','Value',...) creates a new GG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gg

% Last Modified by GUIDE v2.5 17-Feb-2022 15:31:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gg_OpeningFcn, ...
    'gui_OutputFcn',  @gg_OutputFcn, ...
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

% --- Executes just before gg is made visible.
function gg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gg (see VARARGIN)

%
%-------  globalization -----------
%
global plotMODE;
plotMODE = 0;
% plotMODE = 0 - default signal
% plotMODE = 1 - FFT

global dopMODE;
dopMODE = 0;
% dopMODE = 0 - signal
% dopMODE = 1 - signal with awgn
% dopMODE = 2 - signal with noise
% dopMODE = 3 - signal with awgn and noise

% global detectMODE;
% detectMODE = 0;

global tel;
Atex = '';
tel = string(Atex);

global detectTel;

global telN;
telN = [0];
%telN =  [telN, data];

%Кількість точок дискретного сигналу
global N;
N = 2000;

%Частота дискретизації
global fs;
fs=44100;

%Формування вектору дискретного часу
global t;
t=0:1:N-1;
t=t/fs;

%Формування вектору дискретних частот
global f;
f=0:1:N-1;
f=f*fs/N;

%Частота гармонічного сигналу
global Fn;
Fn = [697 770 852 941 1209 1336 1477];

global A;
A = 1;

set(handles.text15,'Enable','off')
set(handles.pushbutton31,'Enable','off')
set(handles.pushbutton33,'Enable','off')
set(handles.pushbutton35,'Enable','off')
set(handles.pushbutton37,'Enable','off')
set(handles.pushbutton52,'Enable','off')
%
%
%
% Choose default command line output for gg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gg wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = gg_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in 1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global tel;
global telN;
global t;
global Fn;
global A;
global Number;
global fs;
global SNR;

f1 = Fn(1);
f2 = Fn(5);
S1 = A * cos(2 * pi * f1 *t);
S2 = A * cos(2 * pi * f2 * t);
DTMFSignal = S1 + S2;
telN = [telN, DTMFSignal];
tel = tel + '1';
set(handles.text2, 'String', tel);

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    %set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in 2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global tel;
global telN;
global t;
global Fn;
global A;
global Number;
global fs;
global SNR;

f1 = Fn(1);
f2 = Fn(6);
S1 = A * cos(2 * pi * f1 *t);
S2 = A * cos(2 * pi * f2 * t);
DTMFSignal = S1 + S2;
telN = [telN, DTMFSignal];
tel = tel + '2';
set(handles.text2, 'String', tel);

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    %set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in 3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global tel;
global telN;
global t;
global SNR;
global Fn;
global A;
global Number;
global fs;

f1 = Fn(1);
f2 = Fn(7);
S1 = A * cos(2 * pi * f1 *t);
S2 = A * cos(2 * pi * f2 * t);
DTMFSignal = S1 + S2;
telN = [telN, DTMFSignal];
tel = tel + '3';
set(handles.text2, 'String', tel);

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    % set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in 4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global tel;
global telN;
global t;
global Fn;
global A;
global Number;
global fs;
global SNR;

f1 = Fn(2);
f2 = Fn(5);
S1 = A * cos(2 * pi * f1 *t);
S2 = A * cos(2 * pi * f2 * t);
DTMFSignal = S1 + S2;
telN = [telN, DTMFSignal];
tel = tel + '4';
set(handles.text2, 'String', tel);

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    %set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end
% --- Executes on button press in 5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global tel;
global telN;
global t;
global Fn;
global A;
global Number;
global fs;
global SNR;

f1 = Fn(2);
f2 = Fn(6);
S1 = A * cos(2 * pi * f1 *t);
S2 = A * cos(2 * pi * f2 * t);
DTMFSignal = S1 + S2;
telN = [telN, DTMFSignal];
tel = tel + '5';
set(handles.text2, 'String', tel);

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    %set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in 6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global tel;
global telN;
global t;
global Fn;
global A;
global Number;
global fs;
global SNR;

f1 = Fn(2);
f2 = Fn(7);
S1 = A * cos(2 * pi * f1 *t);
S2 = A * cos(2 * pi * f2 * t);
DTMFSignal = S1 + S2;
telN = [telN, DTMFSignal];
tel = tel + '6';
set(handles.text2, 'String', tel);

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    %set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in 7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global tel;
global telN;
global t;
global Fn;
global A;
global SNR;

f1 = Fn(3);
f2 = Fn(5);
S1 = A * cos(2 * pi * f1 *t);
S2 = A * cos(2 * pi * f2 * t);
DTMFSignal = S1 + S2;
telN = [telN, DTMFSignal];
tel = tel + '7';
set(handles.text2, 'String', tel);

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    %set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in 8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global tel;
global telN;
global t;
global Fn;
global A;
global Number;
global fs;
global SNR;

f1 = Fn(3);
f2 = Fn(6);
S1 = A * cos(2 * pi * f1 *t);
S2 = A * cos(2 * pi * f2 * t);
DTMFSignal = S1 + S2;
telN = [telN, DTMFSignal];
tel = tel + '8';
set(handles.text2, 'String', tel);

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    %set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in 9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global tel;
global telN;
global t;
global Fn;
global A;
global Number;
global fs;
global SNR;

f1 = Fn(3);
f2 = Fn(7);
S1 = A * cos(2 * pi * f1 *t);
S2 = A * cos(2 * pi * f2 * t);
DTMFSignal = S1 + S2;
telN = [telN, DTMFSignal];
tel = tel + '9';
set(handles.text2, 'String', tel);

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    % set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in *.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global tel;
global telN;
global t;
global Fn;
global A;
global Number;
global fs;
global SNR;

f1 = Fn(4);
f2 = Fn(5);
S1 = A * cos(2 * pi * f1 *t);
S2 = A * cos(2 * pi * f2 * t);
DTMFSignal = S1 + S2;
telN = [telN, DTMFSignal];
tel = tel + '*';
set(handles.text2, 'String', tel);

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    %set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in 0.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global tel;
global telN;
global t;
global Fn;
global A;
global Number;
global fs;
global SNR;

f1 = Fn(4);
f2 = Fn(6);
S1 = A * cos(2 * pi * f1 *t);
S2 = A * cos(2 * pi * f2 * t);
DTMFSignal = S1 + S2;
telN = [telN, DTMFSignal];
tel = tel + '0';
set(handles.text2, 'String', tel);

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    %set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in #.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global tel;
global telN;
global t;
global Fn;
global A;
global Number;
global fs;
global SNR;

f1 = Fn(4);
f2 = Fn(7);
S1 = A * cos(2 * pi * f1 *t);
S2 = A * cos(2 * pi * f2 * t);
DTMFSignal = S1 + S2;
telN = [telN, DTMFSignal];
tel = tel + '#';
set(handles.text2, 'String', tel);

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    % set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end
% --- Executes on button press in infoguide.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure('Name','Author')
axis('off')
text(0,0.6,'REF <3', 'Color',[0.1 0.1 1],'Fontsize',14)
%text(0,0.5,'РТ', 'Color',[0.1 0.1 1],'Fontsize',14)
text(0,0.4, 'Grandum)', 'Color',[0.1 0.1 1],'Fontsize',14)

% % --- Executes on button press in pushbutton21.
% function pushbutton21_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton21 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Plot.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global telN;
global plotMODE;
global dopMODE;
global A;
global t;
global Number;
global fs;
global SNR;

plotMODE = 0;

% check mode
if plotMODE == 0
    
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    %set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% % --- Executes on button press in togglebutton2.
% function togglebutton2_Callback(hObject, eventdata, handles)
% % hObject    handle to togglebutton2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% % Hint: get(hObject,'Value') returns toggle state of togglebutton2


% % --- Executes on button press in pushbutton24.
% function pushbutton24_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton24 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)


% % --- Executes on button press in pushbutton28.
% function pushbutton28_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton28 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%

% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in FFT.
function pushbutton30_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global telN;
global plotMODE;
global dopMODE;
global SNR;
global A;
global t;
global Number;
global fs;

plotMODE = 1;

% check mode
if plotMODE == 0
    
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    % set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in AWGN.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global telN;
global SNR;
global plotMODE;
global dopMODE;
global A;
global t;
global Number;
global fs;

if dopMODE == 0
    dopMODE = 1;
end
if dopMODE == 2
    dopMODE = 3;
end

SNR = 0;
set(handles.pushbutton35,'Enable','on')
set(handles.pushbutton37,'Enable','on')
set(handles.text6, 'String', SNR);

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    %set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in Clear.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tel;
global telN;
global plotMODE;
global dopMODE;
global SNR;
plotMODE = 0;
dopMODE = 0;
SNR = 0;
Atex = '';
tel = string(Atex);
telN = [];
cla(handles.axes1);

set(handles.editText2, 'String', '');
set(handles.edit3, 'String', '');
set(handles.text2, 'String', '');
set(handles.text6, 'String', '');
set(handles.text15,'Enable','off')
set(handles.pushbutton1,'Enable','on')
set(handles.pushbutton2,'Enable','on')
set(handles.pushbutton3,'Enable','on')
set(handles.pushbutton4,'Enable','on')
set(handles.pushbutton5,'Enable','on')
set(handles.pushbutton6,'Enable','on')
set(handles.pushbutton7,'Enable','on')
set(handles.pushbutton8,'Enable','on')
set(handles.pushbutton9,'Enable','on')
set(handles.pushbutton17,'Enable','on')
set(handles.pushbutton18,'Enable','on')
set(handles.pushbutton19,'Enable','on')
set(handles.pushbutton31,'Enable','off')
set(handles.pushbutton33,'Enable','off')
set(handles.pushbutton33,'Enable','off')
set(handles.pushbutton35,'Enable','off')
set(handles.pushbutton37,'Enable','off')


% --- Executes on button press in Noise.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global telN;
global plotMODE;
global dopMODE;
global A;
global fs;
global t;
global SNR;

if dopMODE == 0
    dopMODE = 2;
elseif dopMODE == 1
    dopMODE = 3;
end

% check mode
if plotMODE == 0
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    %set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in Exit.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;
clear all;
clc;

% --- Executes on button press in SNR +5.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global telN;
global SNR;
global A;
global t;
global Number;
global fs;

SNR = SNR + 5;
set(handles.text6, 'String', SNR);

% check mode
if plotMODE == 0
    
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    %set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in SNR -5.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global plotMODE;
global dopMODE;
global telN;
global SNR;
global A;
global t;
global Number;
global fs;

SNR = SNR - 5;
set(handles.text6, 'String', SNR);

% check mode
if plotMODE == 0
    
    if dopMODE == 0
        set(handles.text9, 'String', 'Plot');
        plot(handles.axes1, telN);
    elseif dopMODE == 1
        set(handles.text9, 'String', 'Plot +AWGN');
        out_data = awgn(telN, SNR);
        plot(handles.axes1, abs(out_data));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'Plot +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        plot(handles.axes1, telN);
    elseif dopMODE == 3
        set(handles.text9, 'String', 'Plot +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        plot(handles.axes1, telN);
    end
    
elseif plotMODE == 1
    if dopMODE == 0
        set(handles.text9, 'String', 'FFT');
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 1
        set(handles.text9, 'String', 'FFT +AWGN');
        out_data = awgn(telN, SNR);
        FFT = fft(out_data);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 2
        set(handles.text9, 'String', 'FFT +Noise');
        Number = length(telN);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = telN + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    elseif dopMODE == 3
        set(handles.text9, 'String', 'FFT +AWGN+Noise');
        out_data = awgn(telN, SNR);
        Number = length(out_data);
        t=0:1:Number-1;
        t=t/fs;
        S1=A*cos(2*pi*730*t);
        S2=A*cos(2*pi*1300*t);
        telN = out_data + S1 + S2;
        FFT = fft(telN);
        plot(handles.axes1, abs(FFT));
    end
end

% turn on/off dopMODE buttons
if telN == 0
    set(handles.pushbutton31,'Enable','off') % awgn
    % set(handles.pushbutton32,'Enable','off') % clear
    set(handles.pushbutton33,'Enable','off') % noise
    set(handles.pushbutton35,'Enable','off') % snr +
    set(handles.pushbutton37,'Enable','off') % snr -
elseif dopMODE == 0
    set(handles.pushbutton31,'Enable','on')
    set(handles.pushbutton33,'Enable','on')
elseif dopMODE == 1
    set(handles.pushbutton31,'Enable','off') % awgn
elseif dopMODE == 2
    set(handles.pushbutton33,'Enable','off') % noise
elseif dopMODE == 3
    set(handles.pushbutton31,'Enable','off') % awgn
    set(handles.pushbutton33,'Enable','off') % noise
end

% --- Executes on button press in Load.
function pushbutton39_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nameEdit2;
global fs;
global telN;

nameEdit2 = get(handles.editText2, 'String');
nameEdit2 = string(nameEdit2) + '.wav';
nameEdit2 = char(nameEdit2);
%assignin('base', 'nameEdit2', nameEdit2);

[telN, fs] = audioread(nameEdit2);
set(handles.pushbutton52,'Enable','on')

function editText2_Callback(hObject, eventdata, handles)
% hObject    handle to editText2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText2 as text
%        str2double(get(hObject,'String')) returns contents of editText2 as a double
%

% --- Executes during object creation, after setting all properties.
function editText2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Save.
function pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nameEdit2;
global fs;
global telN;

nameEdit2 = get(handles.editText2, 'String');
nameEdit2 = string(nameEdit2) + '.wav';
nameEdit2 = char(nameEdit2);
%assignin('base', 'nameEdit2', nameEdit2);

audiowrite(nameEdit2, telN, fs);

% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton42.
function pushbutton42_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in pushbutton44.
function pushbutton44_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton45.
function pushbutton45_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton46.
function pushbutton46_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton47.
function pushbutton47_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton48.
function pushbutton48_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton48 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton49.
function pushbutton49_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton49 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton50.
function pushbutton50_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton51.
function pushbutton51_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton52.
function pushbutton52_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global telN;
global tel;
global Fn;
global fs;
global N;
global detectTel;
global nameEdit3;

detectTel = [];
detectTel = string(detectTel);


nameEdit3 = get(handles.edit3, 'String');
nameEdit3 = str2num(nameEdit3);

for i = 1 : nameEdit3
    detect = [0 0 0 0 0 0 0];
    for j = 1 : 7
        ind = round(Fn(j) / (fs / N)) + 1;
        val = goertzel(telN(((i - 1 ) * N + 1) : N * i),ind) / N;
        if(abs(val) > 0.2)
            detect(j) = 1;
        end
    end
    if( detect(1) && detect(5))
        detectTel = [detectTel, '1'];
    elseif( detect(1) && detect(6))
        detectTel = [detectTel, '2'];
    elseif( detect(1) && detect(7))
        detectTel = [detectTel, '3'];
    elseif( detect(2) && detect(5))
        detectTel = [detectTel, '4'];
    elseif( detect(2) && detect(6))
        detectTel = [detectTel, '5'];
    elseif( detect(2) && detect(7))
        detectTel = [detectTel, '6'];
    elseif( detect(3) && detect(5))
        detectTel = [detectTel, '7'];
    elseif( detect(3) && detect(6))
        detectTel = [detectTel, '8'];
    elseif( detect(3) && detect(7))
        detectTel = [detectTel, '9'];
    elseif( detect(4) && detect(6))
        detectTel = [detectTel, '0'];
    elseif( detect(4) && detect(5))
        detectTel = [detectTel, '*'];
    elseif( detect(4) && detect(7))
        detectTel = [detectTel, '#'];
    end
end

set(handles.text15,'Enable','on')
set(handles.pushbutton1,'Enable','off')
set(handles.pushbutton2,'Enable','off')
set(handles.pushbutton3,'Enable','off')
set(handles.pushbutton4,'Enable','off')
set(handles.pushbutton5,'Enable','off')
set(handles.pushbutton6,'Enable','off')
set(handles.pushbutton7,'Enable','off')
set(handles.pushbutton8,'Enable','off')
set(handles.pushbutton9,'Enable','off')
set(handles.pushbutton17,'Enable','off')
set(handles.pushbutton18,'Enable','off')
set(handles.pushbutton19,'Enable','off')
%set(handles.pushbutton52,'Enable','off')

detectTel = char( detectTel);
set(handles.text2, 'String', detectTel);



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double






% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton53.
function pushbutton53_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
