import { useNuiEvent } from '../../../hooks/useNuiEvent';
import { Box, createStyles, Flex, Stack, Text } from '@mantine/core';
import { useEffect, useState } from 'react';
import { ContextMenuProps } from '../../../typings';
import ContextButton from './components/ContextButton';
import { fetchNui } from '../../../utils/fetchNui';
import ReactMarkdown from 'react-markdown';
import HeaderButton from './components/HeaderButton';
import ScaleFade from '../../../transitions/ScaleFade';
import MarkdownComponents from '../../../config/MarkdownComponents';
import SearchInput from './components/SearchInput';

const openMenu = (id: string | undefined) => {
  fetchNui<ContextMenuProps>('openContext', { id: id, back: true });
};

const useStyles = createStyles((theme) => ({
  container: {
    position: 'absolute',
    top: '15%',
    right: '25%',
    width: 320,
    height: 580,
  },
  contextcontainer: {
    backgroundColor: '#292929',
    padding: '8px',
    borderRadius: '4px',
    width: 330,
    maxHeight: 700,
    paddingBottom: 20
  },
  header: {
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 10,
    gap: 6,
  },
  titleContainer: {
    flex: '1 100%',
    backgroundColor: '#303030',
    borderBottom: '2px solid #ed5007',

    borderRadius: 0,
  },
  titleText: {
    color: theme.colors.dark[0],
    padding: 6,
    textAlign: 'center',
  },
  buttonsContainer: {
    height: 560,
    overflowY: 'auto',
    marginRight: '-1px', // Add this line
    paddingRight: '5px', // Add this line
  },
  buttonsFlexWrapper: {
    gap: 3,
    padding: '5px',
    backgroundColor: '#303030',
    borderRadius: '5px'
  },
 filterContainer: {
    marginBottom: 10,
    color: 'red',
  }, 
}));

const ContextMenu: React.FC = () => {
  const { classes } = useStyles();
  const [visible, setVisible] = useState(false);
  const [contextMenu, setContextMenu] = useState<ContextMenuProps>({
    title: '',
    options: { '': { description: '', metadata: [] } },
  });

  const [currentFilter, setCurrentFilter] = useState<string>('');

  const closeContext = () => {
    if (contextMenu.canClose === false) return;
    setVisible(false);
    fetchNui('closeContext');
  };

    // resets the filter when a new menu is loaded
    useEffect(() => {
      setCurrentFilter('')
    }, [contextMenu]);
  // Hides the context menu on ESC
  useEffect(() => {
    if (!visible) return;

    const keyHandler = (e: KeyboardEvent) => {
      if (['Escape'].includes(e.code)) closeContext();
    };

    window.addEventListener('keydown', keyHandler);

    return () => window.removeEventListener('keydown', keyHandler);
  }, [visible]);

  useNuiEvent('hideContext', () => setVisible(false));

  useNuiEvent<ContextMenuProps>('showContext', async (data) => {
    if (visible) {
      setVisible(false);
      await new Promise((resolve) => setTimeout(resolve, 100));
    }
    setContextMenu(data);
    setVisible(true);
  });

  return (
    <Box className={classes.container}>
      <ScaleFade visible={visible}>
      <Box className={classes.contextcontainer}>

        <Flex className={classes.header}>
          {contextMenu.menu && (
            <HeaderButton icon="chevron-left" iconSize={16} handleClick={() => openMenu(contextMenu.menu)} />
          )}
          <Box className={classes.titleContainer}>
            <Text className={classes.titleText}>
              <ReactMarkdown components={MarkdownComponents}>{contextMenu.title}</ReactMarkdown>
            </Text>
          </Box>
          <HeaderButton icon="xmark" canClose={contextMenu.canClose} iconSize={18} handleClick={closeContext} />
        </Flex>
        {contextMenu.filter && (
          <Box className={classes.filterContainer}>
            <SearchInput
            value={currentFilter}
              icon="magnifying-glass"
              handleChange={(data) => {
                setCurrentFilter(data.target.value);
              }}
            />
          </Box>
        )}
        <Box className={classes.buttonsContainer}>
          <Stack className={classes.buttonsFlexWrapper}>
          {Object.entries(contextMenu.options).map((option, index) =>
              currentFilter !== '' ? (
                ((option[1].title && option[1].title.toLowerCase().includes(currentFilter.toLowerCase())) ||
                  (option[1].description &&
                    option[1].description.toLowerCase().includes(currentFilter.toLowerCase()))) && (
                  <ContextButton option={option} key={`context-item-${index}`} />
                )
              ) : (
                <ContextButton option={option} key={`context-item-${index}`} />
              )
            )}
          </Stack>
        </Box>
        </Box>
      </ScaleFade>
    </Box>
  );
};

export default ContextMenu;
