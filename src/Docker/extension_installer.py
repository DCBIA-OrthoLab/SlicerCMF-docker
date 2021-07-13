"""Install space-separated list of extension names

Adapted from https://github.com/pieper/SlicerDockers/blob/83d04792f6c7032c9a1d8a5d1aa041994d094a86/slicer-plus/install-slicer-extension.py
"""

import slicer
import os

extensions = os.environ['SLICER_EXTENSIONS']

for extensionName in extensions.split():
    print(f"installing {extensionName}")
    emm = slicer.app.extensionsManagerModel()
    extensionMetaData = emm.retrieveExtensionMetadataByName(extensionName)
    if not extensionMetaData:
        print(f'could not find extension {extensionName}')
        continue
    url = emm.serverUrl().toString() + '/download/item/' + extensionMetaData['item_id']
    extensionPackageFilename = slicer.app.temporaryPath + '/' + extensionMetaData['md5']
    slicer.util.downloadFile(url, extensionPackageFilename)
    emm.installExtension(extensionPackageFilename)

exit()
