import pyiqa
import torch, gc
#11

gc.collect()
torch.cuda.empty_cache()
device = torch.device("cuda") if torch.cuda.is_available() else torch.device("cpu")

#TOPIQ(good)
iqa_metric = pyiqa.create_metric('topiq_fr', device=device)

# #AHIQ(GPU not good)
# iqa_metric = pyiqa.create_metric('ahiq', device=device)

# #PieAPP(GPU not good)
# iqa_metric = pyiqa.create_metric('pieapp', device=device)

# #LPIPS(good)
# iqa_metric = pyiqa.create_metric('lpips', device=device)

# #DISTS(good)
# iqa_metric = pyiqa.create_metric('dists', device=device)

# #CKDN(good)
# iqa_metric = pyiqa.create_metric('ckdn', device=device)

# #FSIM(good)
# iqa_metric = pyiqa.create_metric('fsim', device=device)

# #SSIM(good)
# iqa_metric = pyiqa.create_metric('ssim', device=device)

# #MS-SSIM(good)
# iqa_metric = pyiqa.create_metric('ms_ssim', device=device)

# #CW-SSIM(good)
# iqa_metric = pyiqa.create_metric('cw_ssim', device=device)

# #PSNR(good)
# iqa_metric = pyiqa.create_metric('psnr', device=device)

# #VIF(not good)
# iqa_metric = pyiqa.create_metric('vif', device=device)

# #GMSD(not good)
# iqa_metric = pyiqa.create_metric('gmsd', device=device)

# #NLPD(good)
# iqa_metric = pyiqa.create_metric('nlpd', device=device)

# #VSI(good)
# iqa_metric = pyiqa.create_metric('vsi', device=device)

# #MAD(GPU not good)
# iqa_metric = pyiqa.create_metric('mad', device=device)

# check if lower better or higher better
print(iqa_metric.lower_better)

# img path as inputs.
score_fr1 = iqa_metric('./Result/0.bmp', './Result/1.bmp')
score_fr2 = iqa_metric('./Result/0.bmp', './Result/2.bmp')
score_fr3 = iqa_metric('./Result/0.bmp', './Result/3.bmp')





print(score_fr1,score_fr2,score_fr3)