From: jerry.hoemann@hp.com
Subject: Re: [PATCH 0/3] Early use of boot service memory
Date: Wed, 13 Nov 2013 18:40:43 -0700
Message-ID: <20131114014043.GD25344@anatevka.fc.hp.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
 <20131113224503.GB25344@anatevka.fc.hp.com>
 <52840206.5020006@zytor.com>
 <20131113235708.GC25344@anatevka.fc.hp.com>
 <528413DE.1090203@zytor.com>
Reply-To: jerry.hoemann@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <528413DE.1090203@zytor.com>
Sender: linux-doc-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org, penberg@kernel.org, akpm@linux-foundation.org, linux-doc@vger.kernel.org, linux-efi@vger.kernel.org, vgoyal@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 13, 2013 at 04:05:50PM -0800, H. Peter Anvin wrote:
> On 11/13/2013 03:57 PM, jerry.hoemann@hp.com wrote:
> > 
> > I think i can go to a date based black list, that removes the manual
> > step.  System running firmware before certain date assumes we need
> > to do the work around.  If firmware is newer than that date, we don't
> > use the workaround.  Blacklist overrides and allows current behavior
> > for new firmware that is subsequently found to be broken and for
> > which we can't convenience the manufacturer to fix.
> > 
> 
> No, we can't, at least not for now.  We are continually finding new
> platforms with the bug.

  Does you have a list of systems that require efi_reserve_boot_services?
  might be useful from a testing standpoint to get access to one.


> 
> > 
> > I will still point out that as currently used, efi_reserve_boot_services
> > is wrong.  A work around for firmware bugs on one platform shouldn't be
> > breaking platforms that don't have that bug.  Its just much less likely
> > to cause problems with higher crash kernel allocation.
> > 
> 
> It is wrong, yes, but it seems like a ubiquitous problem.
> 
> 	-hpa

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard/MODL

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

