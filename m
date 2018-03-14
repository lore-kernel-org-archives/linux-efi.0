From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 2/5] MODSIGN: print appropriate status message when
 getting UEFI certificates list
Date: Wed, 14 Mar 2018 12:40:45 +0800
Message-ID: <20180314044045.GC19718@linux-l9pv.suse>
References: <20180313103559.13032-1-jlee@suse.com>
 <20180313103559.13032-3-jlee@suse.com>
 <1520961470.5360.18.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1520961470.5360.18.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Howells <dhowells@redhat.com>, linux-fs@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi James,

Thanks for your review.

On Tue, Mar 13, 2018 at 10:17:50AM -0700, James Bottomley wrote:
> On Tue, 2018-03-13 at 18:35 +0800, Lee, Chun-Yi wrote:
> > When getting certificates list from UEFI variable, the original error
> > message shows the state number from UEFI firmware. It's hard to be
> > read by human. This patch changed the error message to show the
> > appropriate string.
> > 
> > The message will be showed as:
> > 
> > [    0.788529] MODSIGN: Couldn't get UEFI MokListRT: EFI_NOT_FOUND
> > [    0.788537] MODSIGN: Couldn't get UEFI MokListXRT: EFI_NOT_FOUND
> 
> I keep saying this, but these error messages need to be gated on the
> presence of shim for the non-shim secure boot case.  You can't assume
> the shim variables are there because they won't be in the case of a
> fully owned system.

I will change the message to pr_debug.

Thanks a lot!
Joey Lee 
