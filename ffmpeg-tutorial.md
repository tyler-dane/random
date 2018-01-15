There are many ways to normalize audio, but I think doing it from the command-line is the most rewarding.
This article explains how to normalize audio using `ffmpeg` and its `longform` algorithm. 
- I use Windows 10, but the same process can be applied
to LINUX and OSX. 

## Resources
- [Download ffmpeg](https://ffmpeg.zeranoe.com/builds/)
- [Workflow example 1](http://k.ylo.ph/2016/04/04/loudnorm.html/)[k.ylo.ph]
- [ffmpeg documentation](https://www.ffmpeg.org/ffmpeg.html)[ffmpeg.org]
- [Loudnorm filter syntax](http://ffmpeg.org/ffmpeg-filters.html#loudnorm)[ffmpeg.org]

## Workflow Example

### Download and install `ffmpeg`
### Move to the directory containing your `ffmpeg` binary:

```
cd "C:\Program Files (x86)\ffmpeg\bin"
```

### Input the desired levels and print to terminal:
- In this example, I want to have a LUFS of -18.

```
ffmpeg -i "C:\Users\Local_User1\Dropbox\Website\Podcast\Episodes\000-Welcome\000-Welcome.mp3" -af loudnorm=I=-18:TP=-1.5:LRA=8:print_format=summary -f null -
```

### Read the output to identify what changes would needed to be made in order to get desired levels:

```
[Parsed_loudnorm_0 @ 00000276ed141480]
Input Integrated:    -22.1 LUFS
Input True Peak:      -0.0 dBTP
Input LRA:             5.3 LU
Input Threshold:     -33.0 LUFS

Output Integrated:   -19.0 LUFS
Output True Peak:     -1.5 dBTP
Output LRA:            4.7 LU
Output Threshold:    -29.9 LUFS

Normalization Type:   Dynamic
Target Offset:        +1.0 LU
```

- The important values are `-22.1`, `0.0`, `-33.0`, and `1.0`. 

### Using the output of the previous command, run `ffmpeg` with the `loudnorm` and `measured` flags to create a new file with your desired levels:

```
ffmpeg -i "C:\Users\Local_User1\Dropbox\Website\Podcast\Episodes\000-Welcome\000-Welcome.mp3" -af loudnorm=I=-18:TP=-1.5:LRA=8:measured_I=-22.1:measured_TP=-0.0:measured_thresh=-33.0:offset=-1.0:linear=true:print_format=summary C:\Users\Local_User1\Dropbox\Website\Podcast\Episodes\000-Welcome\000-Welcome_-18LUFS.mp3
```
