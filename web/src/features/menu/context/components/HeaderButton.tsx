import { Button, createStyles } from '@mantine/core';
import { IconProp } from '@fortawesome/fontawesome-svg-core';
import LibIcon from '../../../../components/LibIcon';

interface Props {
  icon: IconProp;
  canClose?: boolean;
  iconSize: number;
  handleClick: () => void;
}

const useStyles = createStyles((theme, params: { canClose?: boolean }) => ({
  button: {
    backgroundColor: '#303030',
    borderBottom: '2px solid #ed5007',
    borderRadius: 0,
    flex: '1 15%',
    alignSelf: 'stretch',
    height: 'auto',
    textAlign: 'center',
    justifyContent: 'center',
    padding: 2,
    '&:hover': {
      backgroundColor: '#303030', 
    },
  },
  root: {
    border: 'none',
  },
  label: {
    color: params.canClose === false ? theme.colors.dark[2] : theme.colors.dark[0],
    '&:hover': {
      color: '#ed5007', 
    },
  },
}));

const HeaderButton: React.FC<Props> = ({ icon, canClose, iconSize, handleClick }) => {
  const { classes } = useStyles({ canClose });

  return (
    <Button
      // variant="default"
      className={classes.button}
      classNames={{ label: classes.label, root: classes.root }}
      disabled={canClose === false}
      onClick={handleClick}
    >
      <LibIcon icon={icon} fontSize={iconSize} fixedWidth />
    </Button>
  );
};

export default HeaderButton;
