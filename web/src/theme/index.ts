import { MantineThemeOverride } from '@mantine/core';
export const theme: MantineThemeOverride = {
  colorScheme: 'dark',
  fontFamily: 'Roboto',
  shadows: { sm: '1px 1px 3px rgba(0, 0, 0, 0.5)' },

  colors: {
    dark: [
      '#C1C2C5', //[0]
      '#A6A7AB', //[1]
      '#909296', //[2]
      '#4f4f4f', //[3]
      '#292929', //[4] --remove
      '#292929', //[5]
      '#212121', //[6] -- search box
      '#1c1c1c', //[7]
      '#141517', //[8]
      '#101113', //[9]
    ],
  },
  components: {
    Button: {
      styles: {
        root: {
          border: 'none',
        },
      },
    },
  },
};