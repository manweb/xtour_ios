//
//  XTSecondViewController.m
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTMapViewController.h"

@interface XTMapViewController ()

@end

@implementation XTMapViewController

@synthesize timerLabel;

- (void)pollTime {
    int tm = (int)singleTimer.timer;
    NSString *currentTimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis      0km",
                                   lround(floor(tm / 3600.)) % 100,
                                   lround(floor(tm / 60.)) % 60,
                                   lround(floor(tm)) % 60];
    self.timerLabel.text = currentTimeString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    singleTimer = [XTDataSingleton singleObj];
    pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:48.0 longitude:8.0 zoom:6];
    mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addLatitude:46.5199807 longitude:7.4661664];
    [path addLatitude:46.5199807 longitude:7.4661664];
    [path addLatitude:46.5200603 longitude:7.4662521];
    [path addLatitude:46.5200144 longitude:7.4663852];
    [path addLatitude:46.5200021 longitude:7.4664811];
    [path addLatitude:46.5200252 longitude:7.4666167];
    [path addLatitude:46.520016 longitude:7.4666814];
    [path addLatitude:46.5200131 longitude:7.4667525];
    [path addLatitude:46.5199992 longitude:7.4668154];
    [path addLatitude:46.5199908 longitude:7.4670193];
    [path addLatitude:46.5199991 longitude:7.4671639];
    [path addLatitude:46.5199764 longitude:7.4673803];
    [path addLatitude:46.5199714 longitude:7.4674574];
    [path addLatitude:46.5199345 longitude:7.46761];
    [path addLatitude:46.5199473 longitude:7.4676779];
    [path addLatitude:46.5199101 longitude:7.4678712];
    [path addLatitude:46.5199134 longitude:7.4680231];
    [path addLatitude:46.5199175 longitude:7.4681775];
    [path addLatitude:46.5199281 longitude:7.4683298];
    [path addLatitude:46.5199178 longitude:7.4684158];
    [path addLatitude:46.5199175 longitude:7.4685214];
    [path addLatitude:46.5198788 longitude:7.4686566];
    [path addLatitude:46.5198765 longitude:7.4688082];
    [path addLatitude:46.5198854 longitude:7.4690103];
    [path addLatitude:46.5198873 longitude:7.4690815];
    [path addLatitude:46.5198575 longitude:7.4692194];
    [path addLatitude:46.5199014 longitude:7.4693332];
    [path addLatitude:46.5199155 longitude:7.4693957];
    [path addLatitude:46.5198712 longitude:7.4695189];
    [path addLatitude:46.5198554 longitude:7.4695942];
    [path addLatitude:46.5198409 longitude:7.4697892];
    [path addLatitude:46.5198015 longitude:7.4699013];
    [path addLatitude:46.5197843 longitude:7.4700298];
    [path addLatitude:46.519701 longitude:7.4702];
    [path addLatitude:46.5196652 longitude:7.4702465];
    [path addLatitude:46.5196598 longitude:7.4703871];
    [path addLatitude:46.5196827 longitude:7.4705064];
    [path addLatitude:46.5196821 longitude:7.4705774];
    [path addLatitude:46.5196076 longitude:7.4708258];
    [path addLatitude:46.5195724 longitude:7.4708722];
    [path addLatitude:46.5195437 longitude:7.4709311];
    [path addLatitude:46.5194944 longitude:7.4711152];
    [path addLatitude:46.5194775 longitude:7.471181];
    [path addLatitude:46.5194598 longitude:7.4712443];
    [path addLatitude:46.5194342 longitude:7.4712991];
    [path addLatitude:46.5193961 longitude:7.4714313];
    [path addLatitude:46.519369 longitude:7.4716264];
    [path addLatitude:46.5193321 longitude:7.471682];
    [path addLatitude:46.5192979 longitude:7.4717628];
    [path addLatitude:46.5192808 longitude:7.4718243];
    [path addLatitude:46.5192347 longitude:7.4719555];
    [path addLatitude:46.5192022 longitude:7.4720086];
    [path addLatitude:46.5191515 longitude:7.4721343];
    [path addLatitude:46.5191074 longitude:7.4721891];
    [path addLatitude:46.5190568 longitude:7.4723111];
    [path addLatitude:46.5190306 longitude:7.4723789];
    [path addLatitude:46.5189843 longitude:7.4725446];
    [path addLatitude:46.5189606 longitude:7.4726008];
    [path addLatitude:46.5189418 longitude:7.4726707];
    [path addLatitude:46.5189239 longitude:7.472817];
    [path addLatitude:46.5188717 longitude:7.4729738];
    [path addLatitude:46.5188299 longitude:7.4731616];
    [path addLatitude:46.518796 longitude:7.4732146];
    [path addLatitude:46.5187605 longitude:7.4732603];
    [path addLatitude:46.5187127 longitude:7.4733885];
    [path addLatitude:46.5186238 longitude:7.4735434];
    [path addLatitude:46.5185639 longitude:7.4736467];
    [path addLatitude:46.5185408 longitude:7.4737793];
    [path addLatitude:46.5185091 longitude:7.473836];
    [path addLatitude:46.5184741 longitude:7.4738964];
    [path addLatitude:46.5184009 longitude:7.4739828];
    [path addLatitude:46.5183755 longitude:7.4740398];
    [path addLatitude:46.5183529 longitude:7.4741114];
    [path addLatitude:46.5183399 longitude:7.4741819];
    [path addLatitude:46.5183055 longitude:7.4742376];
    [path addLatitude:46.5182629 longitude:7.4742901];
    [path addLatitude:46.5182212 longitude:7.4743164];
    [path addLatitude:46.5181844 longitude:7.4743588];
    [path addLatitude:46.5182116 longitude:7.4744346];
    [path addLatitude:46.5181928 longitude:7.4745055];
    [path addLatitude:46.518128 longitude:7.474602];
    [path addLatitude:46.5180275 longitude:7.4747433];
    [path addLatitude:46.5180088 longitude:7.4748097];
    [path addLatitude:46.5179621 longitude:7.4748479];
    [path addLatitude:46.5178729 longitude:7.4749843];
    [path addLatitude:46.5178145 longitude:7.4751189];
    [path addLatitude:46.5177822 longitude:7.4752026];
    [path addLatitude:46.5177477 longitude:7.4752476];
    [path addLatitude:46.5177229 longitude:7.4753055];
    [path addLatitude:46.5177084 longitude:7.4753741];
    [path addLatitude:46.5176682 longitude:7.4754128];
    [path addLatitude:46.5175951 longitude:7.4755895];
    [path addLatitude:46.5175103 longitude:7.4756842];
    [path addLatitude:46.5174011 longitude:7.4759117];
    [path addLatitude:46.5173703 longitude:7.4759602];
    [path addLatitude:46.5173212 longitude:7.4759985];
    [path addLatitude:46.5172733 longitude:7.4760614];
    [path addLatitude:46.5171868 longitude:7.4762263];
    [path addLatitude:46.5171441 longitude:7.4763176];
    [path addLatitude:46.5171377 longitude:7.4763848];
    [path addLatitude:46.5170776 longitude:7.476491];
    [path addLatitude:46.5170336 longitude:7.4765369];
    [path addLatitude:46.5169962 longitude:7.4765898];
    [path addLatitude:46.5169552 longitude:7.4766428];
    [path addLatitude:46.5169042 longitude:7.4767363];
    [path addLatitude:46.5168906 longitude:7.4768051];
    [path addLatitude:46.5168054 longitude:7.4769595];
    [path addLatitude:46.5167605 longitude:7.4770745];
    [path addLatitude:46.5167269 longitude:7.4771192];
    [path addLatitude:46.5167022 longitude:7.477181];
    [path addLatitude:46.5167203 longitude:7.4772409];
    [path addLatitude:46.5166809 longitude:7.4773006];
    [path addLatitude:46.5166395 longitude:7.4773523];
    [path addLatitude:46.5165827 longitude:7.4774647];
    [path addLatitude:46.5165509 longitude:7.4775168];
    [path addLatitude:46.5165266 longitude:7.4775846];
    [path addLatitude:46.5165047 longitude:7.4776591];
    [path addLatitude:46.5164141 longitude:7.4778076];
    [path addLatitude:46.5163781 longitude:7.4778965];
    [path addLatitude:46.5163825 longitude:7.4779708];
    [path addLatitude:46.5163412 longitude:7.478108];
    [path addLatitude:46.5162906 longitude:7.4782177];
    [path addLatitude:46.5162694 longitude:7.4782903];
    [path addLatitude:46.5162604 longitude:7.4783563];
    [path addLatitude:46.5161957 longitude:7.4785354];
    [path addLatitude:46.5161925 longitude:7.4786035];
    [path addLatitude:46.5161836 longitude:7.4786889];
    [path addLatitude:46.5161852 longitude:7.4788316];
    [path addLatitude:46.5161551 longitude:7.4789668];
    [path addLatitude:46.5161405 longitude:7.4790324];
    [path addLatitude:46.516159 longitude:7.4791136];
    [path addLatitude:46.5161249 longitude:7.4791774];
    [path addLatitude:46.5160891 longitude:7.4792533];
    [path addLatitude:46.5160573 longitude:7.4793011];
    [path addLatitude:46.5160272 longitude:7.4793888];
    [path addLatitude:46.5159151 longitude:7.4795408];
    [path addLatitude:46.5158581 longitude:7.4796516];
    [path addLatitude:46.5158305 longitude:7.479706];
    [path addLatitude:46.5158424 longitude:7.4797788];
    [path addLatitude:46.5158211 longitude:7.479847];
    [path addLatitude:46.5157953 longitude:7.4799189];
    [path addLatitude:46.5157536 longitude:7.479991];
    [path addLatitude:46.5156727 longitude:7.4801639];
    [path addLatitude:46.5156626 longitude:7.4803035];
    [path addLatitude:46.5156425 longitude:7.4804409];
    [path addLatitude:46.5156692 longitude:7.4805017];
    [path addLatitude:46.5156719 longitude:7.4805723];
    [path addLatitude:46.5156591 longitude:7.4806814];
    [path addLatitude:46.5156285 longitude:7.4808144];
    [path addLatitude:46.5156435 longitude:7.4808796];
    [path addLatitude:46.5155861 longitude:7.4809745];
    [path addLatitude:46.5155631 longitude:7.4810381];
    [path addLatitude:46.5155186 longitude:7.4810934];
    [path addLatitude:46.5154741 longitude:7.4811545];
    [path addLatitude:46.5154492 longitude:7.4812175];
    [path addLatitude:46.5154188 longitude:7.4812787];
    [path addLatitude:46.5154186 longitude:7.4813441];
    [path addLatitude:46.5154059 longitude:7.4814181];
    [path addLatitude:46.5153627 longitude:7.4815045];
    [path addLatitude:46.5152957 longitude:7.4816031];
    [path addLatitude:46.5152366 longitude:7.4817124];
    [path addLatitude:46.5151741 longitude:7.4818197];
    [path addLatitude:46.515103 longitude:7.4819101];
    [path addLatitude:46.5151021 longitude:7.4819792];
    [path addLatitude:46.5150675 longitude:7.4820266];
    [path addLatitude:46.5150271 longitude:7.4820763];
    [path addLatitude:46.5149917 longitude:7.4822102];
    [path addLatitude:46.5150183 longitude:7.4822665];
    [path addLatitude:46.5150318 longitude:7.4824022];
    [path addLatitude:46.5149925 longitude:7.4824512];
    [path addLatitude:46.5149685 longitude:7.4825206];
    [path addLatitude:46.5149514 longitude:7.4825839];
    [path addLatitude:46.514921 longitude:7.482642];
    [path addLatitude:46.5148553 longitude:7.4828144];
    [path addLatitude:46.5148289 longitude:7.4828828];
    [path addLatitude:46.5147908 longitude:7.4829336];
    [path addLatitude:46.5147517 longitude:7.483076];
    [path addLatitude:46.5147449 longitude:7.4831466];
    [path addLatitude:46.5146792 longitude:7.4832518];
    [path addLatitude:46.5146787 longitude:7.4833393];
    [path addLatitude:46.5146424 longitude:7.4834052];
    [path addLatitude:46.5146036 longitude:7.4835297];
    [path addLatitude:46.5145389 longitude:7.4836585];
    [path addLatitude:46.5145268 longitude:7.4837951];
    [path addLatitude:46.5144904 longitude:7.4838424];
    [path addLatitude:46.5144718 longitude:7.4839115];
    [path addLatitude:46.5143915 longitude:7.48401];
    [path addLatitude:46.5143614 longitude:7.4841387];
    [path addLatitude:46.5143317 longitude:7.4841893];
    [path addLatitude:46.5143104 longitude:7.4843301];
    [path addLatitude:46.5143146 longitude:7.4843994];
    [path addLatitude:46.5142356 longitude:7.4844674];
    [path addLatitude:46.5142032 longitude:7.4845174];
    [path addLatitude:46.5141824 longitude:7.4845877];
    [path addLatitude:46.5141342 longitude:7.4847028];
    [path addLatitude:46.5141086 longitude:7.4847724];
    [path addLatitude:46.5141077 longitude:7.4848431];
    [path addLatitude:46.5141265 longitude:7.4849038];
    [path addLatitude:46.5140837 longitude:7.4849343];
    [path addLatitude:46.514016 longitude:7.4850294];
    [path addLatitude:46.5140045 longitude:7.4850972];
    [path addLatitude:46.5140067 longitude:7.4851694];
    [path addLatitude:46.5139683 longitude:7.4852065];
    [path addLatitude:46.5139345 longitude:7.4852624];
    [path addLatitude:46.5138971 longitude:7.4853012];
    [path addLatitude:46.5138596 longitude:7.485344];
    [path addLatitude:46.5137768 longitude:7.4855041];
    [path addLatitude:46.5137589 longitude:7.4855715];
    [path addLatitude:46.5137339 longitude:7.4856694];
    [path addLatitude:46.5137167 longitude:7.485757];
    [path addLatitude:46.5136669 longitude:7.4857986];
    [path addLatitude:46.5136205 longitude:7.4858241];
    [path addLatitude:46.5135444 longitude:7.485916];
    [path addLatitude:46.513494 longitude:7.4859353];
    [path addLatitude:46.5134837 longitude:7.4860032];
    [path addLatitude:46.5134698 longitude:7.4860674];
    [path addLatitude:46.5134456 longitude:7.4861228];
    [path addLatitude:46.5134184 longitude:7.4861778];
    [path addLatitude:46.5134158 longitude:7.4862458];
    [path addLatitude:46.5134103 longitude:7.4863153];
    [path addLatitude:46.5133356 longitude:7.4864214];
    [path addLatitude:46.5132948 longitude:7.4864542];
    [path addLatitude:46.5132354 longitude:7.4864712];
    [path addLatitude:46.5131927 longitude:7.4865087];
    [path addLatitude:46.5131232 longitude:7.486604];
    [path addLatitude:46.5130897 longitude:7.4866526];
    [path addLatitude:46.5130936 longitude:7.4867338];
    [path addLatitude:46.5131038 longitude:7.4868537];
    [path addLatitude:46.5130529 longitude:7.4868514];
    [path addLatitude:46.5129876 longitude:7.4869789];
    [path addLatitude:46.5129257 longitude:7.4870936];
    [path addLatitude:46.5128724 longitude:7.4872794];
    [path addLatitude:46.5128588 longitude:7.487349];
    [path addLatitude:46.512814 longitude:7.4873805];
    [path addLatitude:46.5127704 longitude:7.4874015];
    [path addLatitude:46.5127142 longitude:7.48751];
    [path addLatitude:46.5127335 longitude:7.4875865];
    [path addLatitude:46.5127083 longitude:7.4876525];
    [path addLatitude:46.5125747 longitude:7.4877137];
    [path addLatitude:46.5124842 longitude:7.4877462];
    [path addLatitude:46.5124431 longitude:7.4877842];
    [path addLatitude:46.5124114 longitude:7.4878446];
    [path addLatitude:46.5123915 longitude:7.4879074];
    [path addLatitude:46.5123413 longitude:7.4879227];
    [path addLatitude:46.5122964 longitude:7.4879111];
    [path addLatitude:46.5122489 longitude:7.487937];
    [path addLatitude:46.5122287 longitude:7.4879989];
    [path addLatitude:46.5121666 longitude:7.4881511];
    [path addLatitude:46.5121445 longitude:7.4882127];
    [path addLatitude:46.5121349 longitude:7.4882851];
    [path addLatitude:46.5120576 longitude:7.4883779];
    [path addLatitude:46.5120211 longitude:7.4884999];
    [path addLatitude:46.5119869 longitude:7.4885446];
    [path addLatitude:46.5119497 longitude:7.4885847];
    [path addLatitude:46.5118795 longitude:7.488667];
    [path addLatitude:46.5118379 longitude:7.4887421];
    [path addLatitude:46.5117961 longitude:7.4887849];
    [path addLatitude:46.5117902 longitude:7.4888573];
    [path addLatitude:46.5117633 longitude:7.4889129];
    [path addLatitude:46.5116805 longitude:7.4889784];
    [path addLatitude:46.5116556 longitude:7.4890455];
    [path addLatitude:46.5116105 longitude:7.4891649];
    [path addLatitude:46.5115818 longitude:7.4892162];
    [path addLatitude:46.5115256 longitude:7.489261];
    [path addLatitude:46.5114965 longitude:7.489319];
    [path addLatitude:46.511457 longitude:7.4893685];
    [path addLatitude:46.5113558 longitude:7.489473];
    [path addLatitude:46.511333 longitude:7.4895293];
    [path addLatitude:46.5113107 longitude:7.4895924];
    [path addLatitude:46.5112711 longitude:7.4896285];
    [path addLatitude:46.5112407 longitude:7.4897043];
    [path addLatitude:46.5111919 longitude:7.4897428];
    [path addLatitude:46.5111487 longitude:7.4897743];
    [path addLatitude:46.5111102 longitude:7.4898141];
    [path addLatitude:46.5110805 longitude:7.4898846];
    [path addLatitude:46.511042 longitude:7.4899239];
    [path addLatitude:46.5110046 longitude:7.4899662];
    [path addLatitude:46.5109551 longitude:7.4899794];
    [path addLatitude:46.5108865 longitude:7.4900045];
    [path addLatitude:46.5108557 longitude:7.4900562];
    [path addLatitude:46.5108201 longitude:7.4901056];
    [path addLatitude:46.51073 longitude:7.4901692];
    [path addLatitude:46.5106473 longitude:7.4902447];
    [path addLatitude:46.510607 longitude:7.4902758];
    [path addLatitude:46.5106314 longitude:7.4904165];
    [path addLatitude:46.5106279 longitude:7.4904872];
    [path addLatitude:46.5105953 longitude:7.4905435];
    [path addLatitude:46.5105365 longitude:7.4905603];
    [path addLatitude:46.5105176 longitude:7.4906215];
    [path addLatitude:46.5104907 longitude:7.4906793];
    [path addLatitude:46.510481 longitude:7.4907566];
    [path addLatitude:46.510446 longitude:7.4908053];
    [path addLatitude:46.5104045 longitude:7.4908352];
    [path addLatitude:46.5103637 longitude:7.4908635];
    [path addLatitude:46.5103193 longitude:7.490898];
    [path addLatitude:46.5102729 longitude:7.4909165];
    [path addLatitude:46.5102475 longitude:7.4910458];
    [path addLatitude:46.5102415 longitude:7.491111];
    [path addLatitude:46.5102128 longitude:7.4911679];
    [path addLatitude:46.5101481 longitude:7.4913108];
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blueColor];
    polyline.strokeWidth = 5.f;
    polyline.map = mapView;
    
    [self.view insertSubview:mapView atIndex:0];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
