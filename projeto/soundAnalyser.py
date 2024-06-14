import librosa
import numpy as np
import json

def analyze_audio(file_path, num_slices=360):
    # Load the audio file
    y, sr = librosa.load(file_path)

    # Normalize the audio signal
    y = librosa.util.normalize(y)

    # duration of the audio in seconds
    duration = librosa.get_duration(y=y, sr=sr)

    # Compute the amplitude (unitless)
    amplitude = np.abs(y)

    # amplitude into the desired number of slices
    slice_duration = duration / num_slices
    amplitude_slices = []
    for i in range(num_slices):
        start = int(i * slice_duration * sr)
        end = int((i + 1) * slice_duration * sr)
        amplitude_slices.append(round(float(np.mean(amplitude[start:end])), 3))

    # spectral centroid (frequency in Hz)
    spectral_centroids = librosa.feature.spectral_centroid(y=y, sr=sr)[0]
    times = librosa.times_like(spectral_centroids, sr=sr)
    
    # spectral centroid into the desired number of slices
    frequency_slices = []
    for i in range(num_slices):
        start_time = i * slice_duration
        end_time = (i + 1) * slice_duration
        mask = (times >= start_time) & (times < end_time)
        if np.any(mask):
            frequency_slices.append(round(float(np.mean(spectral_centroids[mask])), 2))
        else:
            frequency_slices.append(0.0)

  
    #mfccs = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=13)
    #mfcc_slices = [list(map(lambda x: round(float(x), 3), mfcc)) for mfcc in mfccs]
    
  
    #tonnetz = librosa.feature.tonnetz(y=y, sr=sr)
    #tonnetz_slices = [list(map(lambda x: round(float(x), 3), t)) for t in tonnetz]
    
  
    #chroma = librosa.feature.chroma_stft(y=y, sr=sr)
    #chroma_slices = [list(map(lambda x: round(float(x), 3), c)) for c in chroma]


    #zero_crossing_rate = librosa.feature.zero_crossing_rate(y)[0]
    #spectral_bandwidth = librosa.feature.spectral_bandwidth(y=y, sr=sr)[0]
    # spectral_contrast = librosa.feature.spectral_contrast(y=y, sr=sr)[0]
    # rmse = librosa.feature.rms(y=y)[0]
    mfccs = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=13)
    tonnetz = librosa.feature.tonnetz(y=y, sr=sr)
    #onset_env = librosa.onset.onset_strength(y=y, sr=sr)
    chroma = librosa.feature.chroma_stft(y=y, sr=sr)
    zero_crossing_rate = librosa.feature.zero_crossing_rate(y)[0]
    spectral_bandwidth = librosa.feature.spectral_bandwidth(y=y, sr=sr)[0]
    spectral_contrast = librosa.feature.spectral_contrast(y=y, sr=sr)[0]
    rmse = librosa.feature.rms(y=y)[0]


 # Compute Spectral Flatness
    flatness = librosa.feature.spectral_flatness(y=y)
    flatness = flatness[0]  # Extract the flatness values
    flatness_slices = []
    for i in range(num_slices):
        start_time = i * slice_duration
        end_time = (i + 1) * slice_duration
        mask = (times >= start_time) & (times < end_time)
        if np.any(mask):
            flatness_slices.append(round(float(np.mean(flatness[mask])), 3))
        else:
            flatness_slices.append(0.0)

    # Slice and average these features
    def slice_and_average(feature):
        slices = []
        for i in range(num_slices):
            start_time = i * slice_duration
            end_time = (i + 1) * slice_duration
            mask = (times >= start_time) & (times < end_time)
            if np.any(mask):
                slices.append(round(float(np.mean(feature[mask])), 3))
            else:
                slices.append(0.0)
        return slices

    #zero_crossing_slices = slice_and_average(zero_crossing_rate)
    #bandwidth_slices = slice_and_average(spectral_bandwidth)
    #contrast_slices = slice_and_average(spectral_contrast)
    #rmse_slices = slice_and_average(rmse)
    zero_crossing_slices = slice_and_average(zero_crossing_rate)
    bandwidth_slices = slice_and_average(spectral_bandwidth)
    contrast_slices = slice_and_average(spectral_contrast)
    rmse_slices = slice_and_average(rmse)
   # mfcc_slices = [slice_and_average(mfcc) for mfcc in mfccs]
   # tonnetz_slices = [slice_and_average(t) for t in tonnetz]
   # onset_slices = slice_and_average(onset_env)
   # chroma_slices = [slice_and_average(c) for c in chroma]

    # Prepare the data for this audio file
    data = {
        "amplitude": amplitude_slices,
        "frequency": frequency_slices,
        "zero_crossing_rate": zero_crossing_slices,
        "spectral_bandwidth": bandwidth_slices,
       # "spectral_contrast": contrast_slices,
        "rmse": rmse_slices,
       # "flatness": flatness
       # "mfcc": mfcc_slices,
       #"tonnetz": tonnetz_slices,
       # "chroma": chroma_slices
    }

    return data

def save_to_json(all_data, output_file):
    with open(output_file, 'w') as f:
        json.dump(all_data, f, indent=4)



file_paths = ['./audio/Chopin-ValsaMinuto.wav', './audio/Chopin-ValsaMinuto.wav', './audio/Chopin-ValsaMinuto.wav']
output_file = './outputData/sound_data.json'

# Analyze each audio file and store the results
all_data = {}
for i, file_path in enumerate(file_paths, start=1):
    song_data = analyze_audio(file_path)
    all_data[f"song{i}"] = song_data

# Save the data to a JSON file
save_to_json(all_data, output_file)
print(f"Analysis data saved to {output_file}")


# tempo, flatness, mfcc
# chromatismo interessante.

# mfcc muito usado e importante de usar.

# librosa.feature.tempo
# librosa.feature.tempo(*, y=None, sr=22050, onset_envelope=None, tg=None, hop_length=512, start_bpm=120, std_bpm=1.0, ac_size=8.0, max_tempo=320.0, aggregate=<function mean>, prior=None)
# Estimate the tempo (beats per minute)


# librosa.feature.spectral_flatness(*, y=None, S=None, n_fft=2048, hop_length=512, win_length=None, window='hann', center=True, pad_mode='constant', amin=1e-10, power=2.0)[source]
# Compute spectral flatness
# Spectral flatness (or tonality coefficient) is a measure to quantify how much noise-like a sound is, as opposed to being tone-like 1. A high spectral flatness (closer to 1.0) indicates the spectrum is similar to white noise. It is often converted to decibel.
