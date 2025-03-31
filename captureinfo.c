#include <stdio.h>
#include <alsa/asoundlib.h>

int main(int argc, char* argv[])
{
  int err;
  snd_pcm_t             *capture_handle;
  snd_pcm_hw_params_t   *hw_params;
  unsigned int min, max;

  // Open audio device
  if ((err = snd_pcm_open (&capture_handle, "hw:0,0", SND_PCM_STREAM_CAPTURE, 0)) < 0)
    exit (1);

  // Allocate hardware parameters
  if ((err = snd_pcm_hw_params_malloc (&hw_params)) < 0)
    exit (1);

  // Initialize parameters
  if ((err = snd_pcm_hw_params_any (capture_handle, hw_params)) < 0)
    exit (1);

  // Get min and max number of channels
  err = snd_pcm_hw_params_get_channels_min(hw_params, &min);
  if (err < 0)
    exit (1);
  fprintf(stdout, "Min channels: %u\n", min);
  err = snd_pcm_hw_params_get_channels_max(hw_params, &max);
  if (err < 0)
    exit (1);
  fprintf(stdout, "Max channels: %u\n", max);

  // Get min and max sample rate
  err = snd_pcm_hw_params_get_rate_min(hw_params, &min, 0);
  if (err < 0)
    exit (1);
  fprintf(stdout, "Min sample rate: %u\n", min);
  err = snd_pcm_hw_params_get_rate_max(hw_params, &max, 0);
  if (err < 0)
    exit (1);
  fprintf(stdout, "Max sample rate: %u\n", max);
}
