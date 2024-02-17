import {
  generateFeaturesDocumentation,
  generateTemplateDocumentation,
} from './generateDocs';

import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';

const argv = yargs(hideBin(process.argv))
  .command('features', '', (y) => {
    return y.command(
      'docs',
      '',
      (y) => {
        return y.options({
          namespace: {
            alias: ['n', 'namespace'],
            type: 'string',
            demandOption: true,
            default: 'hellodword/devcontainer',
          },
          registry: {
            alias: ['r', 'registry'],
            type: 'string',
            demandOption: true,
            default: 'ghcr.io',
          },
          projectFolder: {
            alias: ['p', 'project-folder'],
            type: 'string',
            demandOption: true,
          },
        });
      },
      (argv) => {
        generateFeaturesDocumentation(
          argv.projectFolder,
          argv.registry,
          argv.namespace
        );
      }
    );
  })
  .command('templates', '', (y) => {
    return y.command(
      'docs',
      '',
      (y) => {
        return y.options({
          projectFolder: {
            alias: ['p', 'project-folder'],
            type: 'string',
            demandOption: true,
          },
        });
      },
      (argv) => {
        generateTemplateDocumentation(argv.projectFolder);
      }
    );
  })
  .parseSync();
