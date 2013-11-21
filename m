From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC v2 0/2] Early use of boot service memory
Date: Thu, 21 Nov 2013 23:37:05 +0000
Message-ID: <20131121233705.GA32121@srcf.ucam.org>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
 <20131121230744.GA31592@srcf.ucam.org>
 <528E94D1.2050809@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <528E94D1.2050809@zytor.com>
Sender: linux-doc-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jerry Hoemann <jerry.hoemann@hp.com>, rob@landley.net, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org, akpm@linux-foundation.org, bp@suse.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, penberg@kernel.org, mingo.kernel.org@gmail.com, vgoyal@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 21, 2013 at 03:18:41PM -0800, H. Peter Anvin wrote:
> On 11/21/2013 03:07 PM, Matthew Garrett wrote:
> > This is a problem we have to solve, but I don't think this is the right 
> > way to solve it. Why do we not just reattempt to perform the allocation 
> > immediately after we've freed the boot services regions?
> > 
> 
> Wouldn't the memory map already have gotten scrambled all to hell by then?

If we couldn't map a 64MB region in low memory earlier then it's likely 
to have been because there was a 64MB or greater boot services region.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
