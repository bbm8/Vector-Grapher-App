//
//  FirstViewController.m
//  Vector Calculator
//
//  Created by Vikram Mullick on 5/20/16.
//  Copyright © 2016 Vikram Mullick. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UIView *graphView;
@property (weak, nonatomic) IBOutlet UITextField *ai;
@property (weak, nonatomic) IBOutlet UITextField *aj;
@property (weak, nonatomic) IBOutlet UITextField *ak;
@property (weak, nonatomic) IBOutlet UITextField *bi;
@property (weak, nonatomic) IBOutlet UITextField *bj;
@property (weak, nonatomic) IBOutlet UITextField *bk;
@property AppDelegate *appDelegate;

@end

CAShapeLayer *originLayer;
double aAngle=0;
double bAngle=M_PI/2;

double fieldNumber=1;

double xCenter;
double yCenter;

double max=1;
double a=-2.35;
double n=40;
double s=1;
double al=7.89;
double b=.8;
double lineWidth=.5;
double pi = M_PI+.05;
double aiNumber=1;
double ajNumber=0;
double akNumber=0;
double biNumber=0;
double bjNumber=1;
double bkNumber=0;
double axbiNumber=0;
double axbjNumber=0;
double axbkNumber=1;
double magA=1;
double magB=1;
double magAxB=1;
double angleBetweenRadians=M_PI/2;
double angleDegrees=90;
double dotProd=0;

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];//L0L what do you think this does

    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    xCenter=(self.view.bounds.size.width-30)/2;//center of graph view x
    yCenter=(self.view.bounds.size.height-247)/2;//center of graphView y
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [self.graphView addGestureRecognizer:gestureRecognizer];//add pan gesture
    
    
    self.graphView.clipsToBounds=YES;

    originLayer = [CAShapeLayer layer];
    [originLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(xCenter-3, yCenter-3, 6, 6)] CGPath]];
    [originLayer setStrokeColor:[[UIColor redColor] CGColor]];
    [originLayer setFillColor:[[UIColor redColor] CGColor]];// layer for origin point
   
    self.ai.inputView =[[[NSBundle mainBundle] loadNibNamed:@"numberBoard" owner:self options:NULL] lastObject];
    self.aj.inputView =[[[NSBundle mainBundle] loadNibNamed:@"numberBoard" owner:self options:NULL] lastObject];
    self.ak.inputView =[[[NSBundle mainBundle] loadNibNamed:@"numberBoard" owner:self options:NULL] lastObject];
    self.bi.inputView =[[[NSBundle mainBundle] loadNibNamed:@"numberBoard" owner:self options:NULL] lastObject];
    self.bj.inputView =[[[NSBundle mainBundle] loadNibNamed:@"numberBoard" owner:self options:NULL] lastObject];
    self.bk.inputView =[[[NSBundle mainBundle] loadNibNamed:@"numberBoard" owner:self options:NULL] lastObject];

    self.ai.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.ai.layer.borderWidth=1.0;
    
    self.aj.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.aj.layer.borderWidth=1.0;
    
    self.ak.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.ak.layer.borderWidth=1.0;
    
    self.bi.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.bi.layer.borderWidth=1.0;
    
    self.bj.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.bj.layer.borderWidth=1.0;
    
    self.bk.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.bk.layer.borderWidth=1.0;
    
    [self redraw];//preliminary graph

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) remax
{
    max=fmax(fmax(sqrt(aiNumber*aiNumber+ajNumber*ajNumber+akNumber*akNumber),sqrt(biNumber*biNumber+bjNumber*bjNumber+bkNumber*bkNumber)),sqrt(axbiNumber*axbiNumber+axbjNumber*axbjNumber+axbkNumber*axbkNumber)); // sets the size of the new largest vector
    s=max;//clearly we must resize our plane
}
-(void) redraw
{
    [self.graphView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];//clear view hence the "re"
   
    [self planeGraph];//draw plane normal to axb

    [self aVector];//draw a Vector
    [self bVector];//draw b vector
    [self axbVector];//draw cross product
   
    [[self.graphView layer] addSublayer:originLayer];//draw origin dot
    [self drawALetter];
    [self drawBLetter];
    [self drawAxBLetter];
    [self drawAngle];


    
}
-(void) aMag
{
    magA=sqrt(aiNumber*aiNumber+ajNumber*ajNumber+akNumber*akNumber);
}
-(void) bMag
{
    magB=sqrt(biNumber*biNumber+bjNumber*bjNumber+bkNumber*bkNumber);

}
-(void) axbMag
{
    magAxB=sqrt(axbiNumber*axbiNumber+axbjNumber*axbjNumber+axbkNumber*axbkNumber);

}

-(void) adotb
{
    dotProd=aiNumber*biNumber+ajNumber*bjNumber+akNumber*bkNumber;
}
-(void) angle
{
    angleBetweenRadians=acos(dotProd/magA/magB);


    angleDegrees=angleBetweenRadians*180/M_PI;
}
-(void) drawAngle
{
    double labelAngle = (aAngle+bAngle)/2;
    UILabel* angleLabel = [[UILabel alloc]initWithFrame:CGRectMake(([self xx]*max/2*cos(labelAngle)+[self yx]*max/2*sin(labelAngle)+[self zx]*akNumber)*[self scaler]+xCenter-30,yCenter-([self xy]*max/2*cos(labelAngle)+[self yy]*max/2*sin(labelAngle)+[self zy]*akNumber)*[self scaler], 100, 12)];
    angleLabel.text = [NSString stringWithFormat:@"θ=%.03f°", angleDegrees];

    angleLabel.backgroundColor = [UIColor clearColor];
    angleLabel.textColor = [UIColor whiteColor];
    [self.graphView addSubview:angleLabel];

}
-(void) drawALetter
{
    UILabel* aLetter = [[UILabel alloc]initWithFrame:CGRectMake(([self xx]*aiNumber+[self yx]*ajNumber+[self zx]*akNumber)*[self scaler]+xCenter,yCenter-([self xy]*aiNumber+[self yy]*ajNumber+[self zy]*akNumber)*[self scaler], 12, 12)];
    aLetter.text = @"a";
    aLetter.backgroundColor = [UIColor clearColor];
    aLetter.textColor = [UIColor redColor];
    [self.graphView addSubview:aLetter];

}
-(void) drawBLetter
{
    UILabel* bLetter = [[UILabel alloc]initWithFrame:CGRectMake(([self xx]*biNumber+[self yx]*bjNumber+[self zx]*bkNumber)*[self scaler]+xCenter,yCenter-([self xy]*biNumber+[self yy]*bjNumber+[self zy]*bkNumber)*[self scaler], 12, 12)];
    bLetter.text = @"b";
    bLetter.backgroundColor = [UIColor clearColor];
    bLetter.textColor = [UIColor redColor];
    [self.graphView addSubview:bLetter];
    
}
-(void) drawAxBLetter
{
    UILabel* axbLetter = [[UILabel alloc]initWithFrame:CGRectMake(([self xx]*axbiNumber+[self yx]*axbjNumber+[self zx]*axbkNumber)*[self scaler]+xCenter,yCenter-([self xy]*axbiNumber+[self yy]*axbjNumber+[self zy]*axbkNumber)*[self scaler], 36, 12)];
    axbLetter.text = @"axb";
    axbLetter.backgroundColor = [UIColor clearColor];
    axbLetter.textColor = [UIColor redColor];
    [self.graphView addSubview:axbLetter];
    
}
-(void) planeGraph
{
    for(int temp=0; temp<=n-1; temp++)
    {
        [self whiteGraph:temp/(n+1) :(temp+1)/(n+1)];
        [self orangeGraph2:temp/(n+1) :(temp+1)/(n+1)];

    }
    for(int temp=(n-1)*aAngle/(2*M_PI)+1; temp<=(n-1)*bAngle/(2*M_PI); temp++)
    {
        [self orangeGraph:temp/(n+1) :(temp+1)/(n+1)];
        
    }
}
-(void) aVector
{
    UIBezierPath *a = [UIBezierPath bezierPath];
    [a moveToPoint:CGPointMake(xCenter,yCenter)];
    [a addLineToPoint:CGPointMake(([self xx]*aiNumber+[self yx]*ajNumber+[self zx]*akNumber)*[self scaler]+xCenter,yCenter-([self xy]*aiNumber+[self yy]*ajNumber+[self zy]*akNumber)*[self scaler])];
    CAShapeLayer *aLayer = [CAShapeLayer layer];
    aLayer.path = a.CGPath;
    aLayer.strokeColor = [UIColor greenColor].CGColor; //etc...
    aLayer.lineWidth = 2.0; //etc...
    aLayer.position = CGPointMake(0, 0); //etc...
    aLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.graphView.layer addSublayer:aLayer];
}

-(void) bVector
{
    UIBezierPath *b = [UIBezierPath bezierPath];
    [b moveToPoint:CGPointMake(xCenter,yCenter)];
    [b addLineToPoint:CGPointMake(([self xx]*biNumber+[self yx]*bjNumber+[self zx]*bkNumber)*[self scaler]+xCenter,yCenter-([self xy]*biNumber+[self yy]*bjNumber+[self zy]*bkNumber)*[self scaler])];
    CAShapeLayer *bLayer = [CAShapeLayer layer];
    bLayer.path = b.CGPath;
    bLayer.strokeColor = [UIColor greenColor].CGColor; //etc...
    bLayer.lineWidth = 2.0; //etc...
    bLayer.position = CGPointMake(0, 0); //etc...
    bLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.graphView.layer addSublayer:bLayer];
}
-(void) axbVector
{
    UIBezierPath *axb = [UIBezierPath bezierPath];
    [axb moveToPoint:CGPointMake(xCenter,yCenter)];
    [axb addLineToPoint:CGPointMake(([self xx]*axbiNumber+[self yx]*axbjNumber+[self zx]*axbkNumber)*[self scaler]+xCenter,yCenter-([self xy]*axbiNumber+[self yy]*axbjNumber+[self zy]*axbkNumber)*[self scaler])];
    CAShapeLayer *axbLayer = [CAShapeLayer layer];
    axbLayer.path = axb.CGPath;
    axbLayer.strokeColor = [UIColor greenColor].CGColor; //etc...
    axbLayer.lineWidth = 2.0; //etc...
    axbLayer.position = CGPointMake(0, 0); //etc...
    axbLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.graphView.layer addSublayer:axbLayer];
}
- (IBAction)calculate:(id)sender
{
    aiNumber=[[self.ai text] doubleValue];
    ajNumber=[[self.aj text] doubleValue];
    akNumber=[[self.ak text] doubleValue];
    
    biNumber=[[self.bi text] doubleValue];
    bjNumber=[[self.bj text] doubleValue];
    bkNumber=[[self.bk text] doubleValue];
    
    [self crossProduct];

    [self axbMag];
    [self aMag];
    [self bMag];
    [self adotb];
    [self angle];
    
    
    [self remax];

    aAngle=atan(ajNumber/aiNumber);
    bAngle=atan(bjNumber/biNumber);
    if(aiNumber<0)
        aAngle+=M_PI;
    if(biNumber<0)
        bAngle+=M_PI;
    if(aAngle>bAngle)
    {
        double temp = aAngle;
        aAngle=bAngle;
        bAngle=temp;
    }//bAngle+=2*M_PI;

    
    [self redraw];
    [self remakeDataString];
}
-(void) remakeDataString
{
    self.appDelegate.calculationDataString=[NSString stringWithFormat:@"a x b = <%.01f,%.01f,%.01f>\n\n a•b = %.01f\n\n |a| = %.01f\n\n |b| = %.01f\n\n |a x b| = %.01f\n\n angle = %.01fº", axbiNumber,axbjNumber,axbkNumber,dotProd,magA,magB,magAxB,angleDegrees];
}
-(void) crossProduct
{
    axbiNumber=ajNumber*bkNumber-akNumber*bjNumber;
    axbjNumber=akNumber*biNumber-aiNumber*bkNumber;
    axbkNumber=aiNumber*bjNumber-ajNumber*biNumber;

    
    
}

-(double) xx
{
    return cos(a);
}
-(double) xy
{
    return sin(a)*sin(b);
}
-(double) yx
{
    return -sin(a);
}
-(double) yy
{
    return cos(a)*sin(b);
}
-(double) zx
{
    return 0;
}
-(double) zy
{
    return cos(b);
}
-(double) g:(double) t
{
    return 2*s*(floor(t*(n+1))/n-.5);
}
-(double) h:(double) t
{
    return 2*s*(fmod(t*(n+1),1)-.5);
}
-(double) gp:(double) t
{
    return 2*s*(floor(t*(n+1))/n-.5);//+s/2;
}
-(double) hp:(double) t
{
    return 2*s*(fmod(t*(n+1),1)-.5);//+s/2;
}
-(double) g2:(double) t
{
    return 2*pi*(floor(t*(n+1))/n-.5)+pi;
}
-(double) h2:(double) t
{
    return 2*pi*(fmod(t*(n+1),1)-.5)+pi;
}
-(double) g3:(double) t
{
    return pi*(floor(t*(n+1))/n-.5)+pi/2;
}
- (double) scaler
{
    return xCenter/max;
}
-(double) h3:(double) t
{
    return pi*(fmod(t*(n+1),1)-.5)+pi/2;
}
- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    double velocityX = ([recognizer velocityInView:self.graphView].x);
    double velocityY = ([recognizer velocityInView:self.graphView].y);
    
    double speedScale = .001;
    
    a+=velocityX*speedScale;
    b+=velocityY*speedScale;
    
    
    if(b>1.40)
        b=1.40;
    if(b<.20)
        b=.20;
    
    [self redraw];
    
}
-(void) whiteGraph: (double)start : (double)end
{
    Boolean hasStarted=false;
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    // Set the starting point of the shape.
    
    for(double t=start;t<=end;t+=.001)
    {
        double currentx=0;
        double currenty=0;
       

        double gp=[self gp:t];
        if(gp<0)gp*=-1;
        double h2=[self h2:t];
        currentx=[self xx]*gp*cos(h2)+[self yx]*gp*sin(h2);
        if(axbkNumber!=0)
            currenty=[self xy]*gp*cos(h2)+[self yy]*gp*sin(h2)+[self zy]*-1*gp*(axbiNumber*cos(h2)+axbjNumber*sin(h2))/axbkNumber;
        else
            currenty=[self xy]*gp*cos(h2)+[self yy]*gp*sin(h2)+[self zy]*-1*gp*(axbiNumber*cos(h2)+axbjNumber*sin(h2))/.00001;
        
       
        currentx=currentx/max*xCenter;
        currenty=currenty/max*xCenter;
        if(currenty==currenty &&currentx==currentx)
        {
            if(!hasStarted)
            {
                [aPath moveToPoint:CGPointMake(xCenter+currentx, yCenter-currenty)];
                hasStarted=true;
                
            }
            else
            {
                [aPath addLineToPoint:CGPointMake(xCenter+currentx, yCenter-currenty)];
            }
            
            
        }
        
        
        
        
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = aPath.CGPath;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor; //etc...
    shapeLayer.lineWidth = lineWidth; //etc...
    shapeLayer.position = CGPointMake(0, 0); //etc...
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [self.graphView.layer addSublayer:shapeLayer];
}
-(void) orangeGraph2: (double)start : (double)end
{
    Boolean hasStarted=false;
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    // Set the starting point of the shape.
    
    for(double t=start;t<=end;t+=.001)
    {
        double currentx=0;
        double currenty=0;
        
        
        double gp=[self gp:t];
        if(gp<0)gp*=-1;
        double h2=[self h2:t];
        currentx=[self xx]*gp*cos(h2)+[self yx]*gp*sin(h2);
        if(axbkNumber!=0)
            currenty=[self xy]*gp*cos(h2)+[self yy]*gp*sin(h2)+[self zy]*-1*gp*(axbiNumber*cos(h2)+axbjNumber*sin(h2))/axbkNumber;
        else
            currenty=[self xy]*gp*cos(h2)+[self yy]*gp*sin(h2)+[self zy]*-1*gp*(axbiNumber*cos(h2)+axbjNumber*sin(h2))/.00001;
        
        
        currentx=currentx/max*xCenter;
        currenty=currenty/max*xCenter;
        if(currenty==currenty &&currentx==currentx && h2>=aAngle-M_PI/20 && h2<=bAngle+M_PI/20)
        {
            if(!hasStarted)
            {
                [aPath moveToPoint:CGPointMake(xCenter+currentx, yCenter-currenty)];
                hasStarted=true;
                
            }
            else
            {
                [aPath addLineToPoint:CGPointMake(xCenter+currentx, yCenter-currenty)];
            }
            
            
        }
        
        
        
        
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = aPath.CGPath;
    shapeLayer.strokeColor = [UIColor orangeColor].CGColor; //etc...
    shapeLayer.lineWidth = lineWidth; //etc...
    shapeLayer.position = CGPointMake(0, 0); //etc...
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [self.graphView.layer addSublayer:shapeLayer];
}
-(void) orangeGraph: (double)start : (double)end
{
    Boolean hasStarted=false;
    UIBezierPath *aPath;
    // Set the starting point of the shape.
    for(double t=start;t<=end;t+=.001)
    {
        double currentx=0;
        double currenty=0;
        
        
        double hp=[self hp: t];
        if(hp<0)hp*=-1;

        double g2=[self g2:t];
        
        currentx=[self xx]*hp*cos(g2)+[self yx]*hp*sin(g2);
       
        if(axbkNumber!=0)
            currenty=[self xy]*hp*cos(g2)+[self yy]*hp*sin(g2)+[self zy]*-1*hp*(axbiNumber*cos(g2)+axbjNumber*sin(g2))/axbkNumber;
        else
            currenty=[self xy]*hp*cos(g2)+[self yy]*hp*sin(g2)+[self zy]*-1*hp*(axbiNumber*cos(g2)+axbjNumber*sin(g2))/.00001;
        
            
        currentx=currentx/max*xCenter;
        currenty=currenty/max*xCenter;
        if(currenty==currenty &&currentx==currentx)
        {
            if(!hasStarted)
            {
                aPath = [UIBezierPath bezierPath];
                
                [aPath moveToPoint:CGPointMake(xCenter+currentx, yCenter-currenty)];
                hasStarted=true;
                
            }
            else
            {
                [aPath addLineToPoint:CGPointMake(xCenter+currentx, yCenter-currenty)];
            }
            
            
        }
        
        
        
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = aPath.CGPath;
    shapeLayer.strokeColor = [UIColor orangeColor].CGColor; //etc...
    shapeLayer.lineWidth = lineWidth+.25; //etc...
    shapeLayer.position = CGPointMake(0, 0); //etc...
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [self.graphView.layer addSublayer:shapeLayer];
}
- (IBAction)aiEndEdit:(id)sender {
    self.ai.text=[NSString stringWithFormat:@"%g", [self.ai.text doubleValue]];
}
- (IBAction)ajEndEdit:(id)sender {
    self.aj.text=[NSString stringWithFormat:@"%g", [self.aj.text doubleValue]];
}
- (IBAction)akEndEdit:(id)sender {  self.ak.text=[NSString stringWithFormat:@"%g", [self.ak.text doubleValue]];
}
- (IBAction)biEndEdit:(id)sender {
    self.bi.text=[NSString stringWithFormat:@"%g", [self.bi.text doubleValue]];
}
- (IBAction)bjEndEdit:(id)sender {  self.bj.text=[NSString stringWithFormat:@"%g", [self.bj.text doubleValue]];
}
- (IBAction)bkEndEdit:(id)sender {
    self.bk.text=[NSString stringWithFormat:@"%g", [self.bk.text doubleValue]];
}
- (IBAction)aiDidBegin:(id)sender {
    fieldNumber=1;
}
- (IBAction)ajDidBegin:(id)sender {
    fieldNumber=2;

}
- (IBAction)akDidBegin:(id)sender {    fieldNumber=3;

}
- (IBAction)biDidBegin:(id)sender {    fieldNumber=4;

}
- (IBAction)bjDidBegin:(id)sender {    fieldNumber=5;

}
- (IBAction)bkDidBegin:(id)sender {    fieldNumber=6;

}


- (IBAction)one:(id)sender
{
    NSString *out = @"1";
    
    if(fieldNumber==1)
    {
        self.ai.text=[self.ai.text stringByAppendingString:out];
    }
    if(fieldNumber==2)
    {
        self.aj.text=[self.aj.text stringByAppendingString:out];
    }
    if(fieldNumber==3)
    {
        self.ak.text=[self.ak.text stringByAppendingString:out];
    }
    if(fieldNumber==4)
    {
        self.bi.text=[self.bi.text stringByAppendingString:out];
    }
    if(fieldNumber==5)
    {
        self.bj.text=[self.bj.text stringByAppendingString:out];
    }
    if(fieldNumber==6)
    {
        self.bk.text=[self.bk.text stringByAppendingString:out];
    }
  
}
- (IBAction)two:(id)sender
{
    NSString *out = @"2";
    
    if(fieldNumber==1)
    {
        self.ai.text=[self.ai.text stringByAppendingString:out];
    }
    if(fieldNumber==2)
    {
        self.aj.text=[self.aj.text stringByAppendingString:out];
    }
    if(fieldNumber==3)
    {
        self.ak.text=[self.ak.text stringByAppendingString:out];
    }
    if(fieldNumber==4)
    {
        self.bi.text=[self.bi.text stringByAppendingString:out];
    }
    if(fieldNumber==5)
    {
        self.bj.text=[self.bj.text stringByAppendingString:out];
    }
    if(fieldNumber==6)
    {
        self.bk.text=[self.bk.text stringByAppendingString:out];
    }
    
}
- (IBAction)three:(id)sender
{
    NSString *out = @"3";
    
    if(fieldNumber==1)
    {
        self.ai.text=[self.ai.text stringByAppendingString:out];
    }
    if(fieldNumber==2)
    {
        self.aj.text=[self.aj.text stringByAppendingString:out];
    }
    if(fieldNumber==3)
    {
        self.ak.text=[self.ak.text stringByAppendingString:out];
    }
    if(fieldNumber==4)
    {
        self.bi.text=[self.bi.text stringByAppendingString:out];
    }
    if(fieldNumber==5)
    {
        self.bj.text=[self.bj.text stringByAppendingString:out];
    }
    if(fieldNumber==6)
    {
        self.bk.text=[self.bk.text stringByAppendingString:out];
    }
    
}
- (IBAction)four:(id)sender
{
    NSString *out = @"4";
    
    if(fieldNumber==1)
    {
        self.ai.text=[self.ai.text stringByAppendingString:out];
    }
    if(fieldNumber==2)
    {
        self.aj.text=[self.aj.text stringByAppendingString:out];
    }
    if(fieldNumber==3)
    {
        self.ak.text=[self.ak.text stringByAppendingString:out];
    }
    if(fieldNumber==4)
    {
        self.bi.text=[self.bi.text stringByAppendingString:out];
    }
    if(fieldNumber==5)
    {
        self.bj.text=[self.bj.text stringByAppendingString:out];
    }
    if(fieldNumber==6)
    {
        self.bk.text=[self.bk.text stringByAppendingString:out];
    }
    
}
- (IBAction)five:(id)sender
{
    NSString *out = @"5";
    
    if(fieldNumber==1)
    {
        self.ai.text=[self.ai.text stringByAppendingString:out];
    }
    if(fieldNumber==2)
    {
        self.aj.text=[self.aj.text stringByAppendingString:out];
    }
    if(fieldNumber==3)
    {
        self.ak.text=[self.ak.text stringByAppendingString:out];
    }
    if(fieldNumber==4)
    {
        self.bi.text=[self.bi.text stringByAppendingString:out];
    }
    if(fieldNumber==5)
    {
        self.bj.text=[self.bj.text stringByAppendingString:out];
    }
    if(fieldNumber==6)
    {
        self.bk.text=[self.bk.text stringByAppendingString:out];
    }
    
}
- (IBAction)six:(id)sender
{
    NSString *out = @"6";
    
    if(fieldNumber==1)
    {
        self.ai.text=[self.ai.text stringByAppendingString:out];
    }
    if(fieldNumber==2)
    {
        self.aj.text=[self.aj.text stringByAppendingString:out];
    }
    if(fieldNumber==3)
    {
        self.ak.text=[self.ak.text stringByAppendingString:out];
    }
    if(fieldNumber==4)
    {
        self.bi.text=[self.bi.text stringByAppendingString:out];
    }
    if(fieldNumber==5)
    {
        self.bj.text=[self.bj.text stringByAppendingString:out];
    }
    if(fieldNumber==6)
    {
        self.bk.text=[self.bk.text stringByAppendingString:out];
    }
    
}
- (IBAction)seven:(id)sender
{
    NSString *out = @"7";
    
    if(fieldNumber==1)
    {
        self.ai.text=[self.ai.text stringByAppendingString:out];
    }
    if(fieldNumber==2)
    {
        self.aj.text=[self.aj.text stringByAppendingString:out];
    }
    if(fieldNumber==3)
    {
        self.ak.text=[self.ak.text stringByAppendingString:out];
    }
    if(fieldNumber==4)
    {
        self.bi.text=[self.bi.text stringByAppendingString:out];
    }
    if(fieldNumber==5)
    {
        self.bj.text=[self.bj.text stringByAppendingString:out];
    }
    if(fieldNumber==6)
    {
        self.bk.text=[self.bk.text stringByAppendingString:out];
    }
    
}
- (IBAction)eight:(id)sender
{
    NSString *out = @"8";
    
    if(fieldNumber==1)
    {
        self.ai.text=[self.ai.text stringByAppendingString:out];
    }
    if(fieldNumber==2)
    {
        self.aj.text=[self.aj.text stringByAppendingString:out];
    }
    if(fieldNumber==3)
    {
        self.ak.text=[self.ak.text stringByAppendingString:out];
    }
    if(fieldNumber==4)
    {
        self.bi.text=[self.bi.text stringByAppendingString:out];
    }
    if(fieldNumber==5)
    {
        self.bj.text=[self.bj.text stringByAppendingString:out];
    }
    if(fieldNumber==6)
    {
        self.bk.text=[self.bk.text stringByAppendingString:out];
    }
    
}
- (IBAction)nine:(id)sender
{
    NSString *out = @"9";
    
    if(fieldNumber==1)
    {
        self.ai.text=[self.ai.text stringByAppendingString:out];
    }
    if(fieldNumber==2)
    {
        self.aj.text=[self.aj.text stringByAppendingString:out];
    }
    if(fieldNumber==3)
    {
        self.ak.text=[self.ak.text stringByAppendingString:out];
    }
    if(fieldNumber==4)
    {
        self.bi.text=[self.bi.text stringByAppendingString:out];
    }
    if(fieldNumber==5)
    {
        self.bj.text=[self.bj.text stringByAppendingString:out];
    }
    if(fieldNumber==6)
    {
        self.bk.text=[self.bk.text stringByAppendingString:out];
    }
    
}
- (IBAction)zero:(id)sender
{
    NSString *out = @"0";
    
    if(fieldNumber==1)
    {
        self.ai.text=[self.ai.text stringByAppendingString:out];
    }
    if(fieldNumber==2)
    {
        self.aj.text=[self.aj.text stringByAppendingString:out];
    }
    if(fieldNumber==3)
    {
        self.ak.text=[self.ak.text stringByAppendingString:out];
    }
    if(fieldNumber==4)
    {
        self.bi.text=[self.bi.text stringByAppendingString:out];
    }
    if(fieldNumber==5)
    {
        self.bj.text=[self.bj.text stringByAppendingString:out];
    }
    if(fieldNumber==6)
    {
        self.bk.text=[self.bk.text stringByAppendingString:out];
    }
    
}
- (IBAction)period:(id)sender
{
    NSString *out = @".";
    
    if(fieldNumber==1)
    {
        self.ai.text=[self.ai.text stringByAppendingString:out];
    }
    if(fieldNumber==2)
    {
        self.aj.text=[self.aj.text stringByAppendingString:out];
    }
    if(fieldNumber==3)
    {
        self.ak.text=[self.ak.text stringByAppendingString:out];
    }
    if(fieldNumber==4)
    {
        self.bi.text=[self.bi.text stringByAppendingString:out];
    }
    if(fieldNumber==5)
    {
        self.bj.text=[self.bj.text stringByAppendingString:out];
    }
    if(fieldNumber==6)
    {
        self.bk.text=[self.bk.text stringByAppendingString:out];
    }
    
}
- (IBAction)negative:(id)sender
{
    NSString *out = @"-";
    
    if(fieldNumber==1)
    {
        self.ai.text=[self.ai.text stringByAppendingString:out];
    }
    if(fieldNumber==2)
    {
        self.aj.text=[self.aj.text stringByAppendingString:out];
    }
    if(fieldNumber==3)
    {
        self.ak.text=[self.ak.text stringByAppendingString:out];
    }
    if(fieldNumber==4)
    {
        self.bi.text=[self.bi.text stringByAppendingString:out];
    }
    if(fieldNumber==5)
    {
        self.bj.text=[self.bj.text stringByAppendingString:out];
    }
    if(fieldNumber==6)
    {
        self.bk.text=[self.bk.text stringByAppendingString:out];
    }
    
}
- (IBAction)del:(id)sender
{
    if(fieldNumber==1)
    {
        if(self.ai.text.length>0)
            self.ai.text=[self.ai.text substringWithRange:NSMakeRange(0, self.ai.text.length-1)];
        
    }
    if(fieldNumber==2)
    {
        if(self.aj.text.length>0)
            self.aj.text=[self.aj.text substringWithRange:NSMakeRange(0, self.aj.text.length-1)];
        
    }
    if(fieldNumber==3)
    {
        if(self.ak.text.length>0)
            self.ak.text=[self.ak.text substringWithRange:NSMakeRange(0, self.ak.text.length-1)];
        
    }
    if(fieldNumber==4)
    {
        if(self.bi.text.length>0)
            self.bi.text=[self.bi.text substringWithRange:NSMakeRange(0, self.bi.text.length-1)];
        
    }
    if(fieldNumber==5)
    {
        if(self.bj.text.length>0)
            self.bj.text=[self.bj.text substringWithRange:NSMakeRange(0, self.bj.text.length-1)];
        
    }
    if(fieldNumber==6)
    {
        if(self.bk.text.length>0)
            self.bk.text=[self.bk.text substringWithRange:NSMakeRange(0, self.bk.text.length-1)];
        
    }
    
}

- (IBAction)tap:(id)sender
{
    [self.view endEditing:YES];

}



@end
