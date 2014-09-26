From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH] partitions: efi.c: fix formatting and function
 readability
Date: Fri, 26 Sep 2014 16:23:49 -0700
Message-ID: <1411773829.14568.15.camel@linux-t7sj.site>
References: <1409803640-9682-1-git-send-email-jdpoirier@gmail.com>
	 <20140926155356.GY18635@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140926155356.GY18635-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Joseph Poirier <jdpoirier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 2014-09-26 at 16:53 +0100, Matt Fleming wrote:
> (No response from Davidlohr, try another address)
> 
> On Wed, 03 Sep, at 11:07:20PM, Joseph Poirier wrote:
> > From: jpoirier <jdpoirier-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > 
> > Fixed coding style issues, refactored the protective MBR check
> > function for readability, and removed an explicit return from a
> > function returning void.

Apologies for the late reply, I had not seen this.

This patch does too much, mind sending a series instead?

Thanks,
Davidlohr
