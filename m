From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.10 ~ 3.14] efi: fix the efi 32bit boot failed problem
Date: Thu, 30 Jul 2015 09:59:43 -0700
Message-ID: <20150730165943.GD5515@kroah.com>
References: <1438078879-24705-1-git-send-email-fupan.li@windriver.com>
 <20150730150428.GJ2725@codeblueprint.co.uk>
 <20150730163102.GA19943@kroah.com>
 <20150730164544.GL2725@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150730164544.GL2725@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: fupan.li@windriver.com, linux-kernel@vger.kernel.org, fupanli@gmail.com, linux-efi@vger.kernel.org, Luis Henriques <luis.henriques@canonical.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jul 30, 2015 at 05:45:44PM +0100, Matt Fleming wrote:
> On Thu, 30 Jul, at 09:31:02AM, Greg KH wrote:
> > 
> > Why isn't this an issue in newer kernel releases?  Did this already get
> > fixed by some other patch?  If so, why can't we just take that patch?
> > If not, why not?
>  
> The commit 35d5134b7d5a ("x86/efi: Correct EFI boot stub use of
> code32_start") only exists in the stable trees in that form because
> there was quite a lot of churn in that area in Linus tree that didn't
> get backported.
> 
> So the code in Linus' tree never looked like the code in the stable does
> right now.
> 
> > I _REALLY_ don't like taking patches that are not already in Linus's
> > tree, as it almost always turns out to be the wrong solution.
> 
> Yeah, I think this issue verifies that.

Ugh, what a mess.  Ok, if you get something that works and is in a
format that I can apply it, please resend it properly so that we can do
so.

thanks,

greg k-h
