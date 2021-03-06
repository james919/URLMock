//
//  UMKIntegrationTestCase.m
//  URLMock
//
//  Created by Prachi Gauriar on 2/1/2014.
//  Copyright (c) 2014 Two Toasters, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "UMKIntegrationTestCase.h"

#import <URLMock/URLMock.h>

#import "UMKURLConnectionVerifier.h"

@implementation UMKIntegrationTestCase

+ (void)setUp
{
    [super setUp];
    [UMKMockURLProtocol enable];
}


- (void)setUp
{
    [super setUp];
    [UMKMockURLProtocol reset];
}


+ (void)tearDown
{
    [UMKMockURLProtocol disable];
    [super tearDown];
}


+ (NSOperationQueue *)connectionOperationQueue
{
    static NSOperationQueue *connectionOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connectionOperationQueue = [[NSOperationQueue alloc] init];
        connectionOperationQueue.name = @"com.twotoasters.UMKIntegrationTestCase.connectionOperationQueue";
    });
    
    return connectionOperationQueue;
}


- (id)verifierForConnectionWithURLRequest:(NSURLRequest *)request
{
    id verifier = [UMKMessageCountingProxy messageCountingProxyWithObject:[[UMKURLConnectionVerifier alloc] init]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:verifier startImmediately:NO];
    connection.delegateQueue = [[self class] connectionOperationQueue];
    [connection start];
    return verifier;
}

@end
