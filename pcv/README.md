# PCV and Hib coverage estimates
Secondary bacterial infections are associated with severe disease and increased morbidity and mortality after infection with many respiratory viruses, though it is not yet clear to what extent bacterial superinfections may occur with 2019-nCoV. Spatiotemporally varying estimates of pneumococcal or Hib conjugate vaccine coverage may therefore be of interest to nCoV modelers. To this end, we have spatio-temporal varying estimates of PCV coverage that may facilitate ongoing modeling of this dimension of the outbreak.

## National-level coverage

<img align="right" src="img/pcv3_cov_provisional_sle_1980_2019_national_sm.png?raw=true" width="375px" alt="Provisional estimates of national-level PCV3 coverage for SLE, 1980-2019"/>

IHME produces annual estimates of vaccine coverage at the national level (and at the first administrative level for select countries) as part of the Global Burden of Disease Study using spatiotemporal Gaussian process regression (ST-GPR; see for instance [Lozano *et al*, Lancet (2018)](http://dx.doi.org/10.1016/S0140-6736(18)32281-5)). For GBD 2019, we have produced preliminary updated estimates of vaccine coverage including PCV3 and Hib3 in 204 countries at the national level (and at the first administrative level for 22 countires) for 1980-2019. These estimates of routine childhood immunization incorporate both survey and bias-adjusted administrative data and are accompanied by uncertainty.


## Subnational coverage
In addition, we have produced preliminary estimates of PCV3 and Hib3 coverage in 100 low- and middle-income countries at 5x5 km and first and second administrative levels, from 2000-2018. In their current form, these estimates are produced by first estimating DTP3 coverage using methods outlined in [Mosser *et al*, Lancet (2019)](https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(19)30226-0/fulltext), then adjusting the posterior distribution of DTP3 coverage such that the national-level mean coverage estimate corresponds to  GBD-estimated PCV3 coverage. 

In essence, this crude approach assumes that the relative spatial distribution of PCV3 or Hib3 coverage within a country is the same as the spatial distribution of DTP3 coverage, while accounting for national-level scale up of PCV3 or Hib3 relative to DTP3. This assumption is likely to be reasonable for Hib3 as a component of the pentavalent vaccine but is largely untested for PCV3. Improved methods to better account for subnational variation in the scale-up of PCV3 or Hib3 are under development.

<img src="img/pcv3_cov_provisional_2018_admin_2.jpg?raw=true" alt="Provisional estimates of PCV3 coverage at the second administrative level, 2018"/>

## Requesting estimates
Currently, the work is all provisional, and some of the estimates are undergoing peer review or finalization. We are willing to share preliminary estimates, however -- if you are interested in accessing these provisional estimates, or if you would like to further discuss these methods, please contact Jon Mosser at jmosser@uw.edu.


