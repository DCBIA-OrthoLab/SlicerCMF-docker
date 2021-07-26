import argparse
import os

import itk

def main(args):
    img = args.img
    out = args.out
    min = args.min
    max = args.max

    if not os.path.exists(os.path.dirname(out)):
        os.makedirs(os.path.dirname(out))

    ImageType = itk.Image[itk.SS, 3]
    reader = itk.ImageFileReader[ImageType].New(FileName=img)
    reader.Update()
    itk_img = reader.GetOutput()

    minimumMaximumImageCalculator = itk.MinimumMaximumImageCalculator[ImageType].New()
    minimumMaximumImageCalculator.SetImage(itk_img)
    minimumMaximumImageCalculator.Compute()
    print('min:', minimumMaximumImageCalculator.GetMinimum(),', max:', minimumMaximumImageCalculator.GetMaximum())

    RescaleIntensityImageFilter = itk.RescaleIntensityImageFilter[ImageType, ImageType].New()
    RescaleIntensityImageFilter.SetInput(itk_img)
    RescaleIntensityImageFilter.SetOutputMinimum(min)
    RescaleIntensityImageFilter.SetOutputMaximum(max)
    RescaleIntensityImageFilter.Update()
    rescaled_img = RescaleIntensityImageFilter.GetOutput()

    minimumMaximumImageCalculator = itk.MinimumMaximumImageCalculator[ImageType].New()
    minimumMaximumImageCalculator.SetImage(rescaled_img)
    minimumMaximumImageCalculator.Compute()
    print('min:', minimumMaximumImageCalculator.GetMinimum(),', max:', minimumMaximumImageCalculator.GetMaximum())

    writer = itk.ImageFileWriter[ImageType].New()
    writer.SetFileName(out)
    writer.UseCompressionOn()
    writer.SetInput(rescaled_img)
    writer.Update()



if __name__ ==  '__main__':
	parser = argparse.ArgumentParser(description='Post-processing', formatter_class=argparse.ArgumentDefaultsHelpFormatter)

	input_params = parser.add_argument_group('Input files')
	input_params.add_argument('--img', type=str, help='Input image', required=True)

	output_params = parser.add_argument_group('Output parameters')
	output_params.add_argument('--out', type=str, help='Output filename', required=True)
	output_params.add_argument('--min', type=str, help='Minimum', required=True)
	output_params.add_argument('--max', type=str, help='Maximum', required=True)

	args = parser.parse_args()

	main(args)
