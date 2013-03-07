From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
Date: Thu, 07 Mar 2013 22:15:29 +0000
Message-ID: <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
	 <5138FAD9.7050504@zytor.com> <20130307205915.GF24233@thinkpad-t410>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130307205915.GF24233@thinkpad-t410>
Sender: linux-kernel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-03-07 at 14:59 -0600, Seth Forshee wrote:
> On Thu, Mar 07, 2013 at 12:38:49PM -0800, H. Peter Anvin wrote:
> > On 03/07/2013 09:40 AM, Seth Forshee wrote:
> > > We know that with some firmware implementations writing too much data to
> > > UEFI variables can lead to bricking machines. Recent changes attempt to
> > > address this issue, but for some it may still be prudent to avoid
> > > writing large amounts of data until the solution has been proven on a
> > > wide variety of hardware.
> > > 
> > > Crash dumps or other data from pstore can potentially be a large data
> > > source. Add a new option, CONFIG_EFI_VARS_PSTORE, which can be set to N
> > > to avoid using efivars as a backend to pstore.
> > 
> > What about a command line option?
> 
> That could be done. I'm assuming you want this instead of a config
> option, defaulted to on?
> 
> How would you feel about a config option for the default value of the
> command line option? I intend to default this to off in Ubuntu for a
> while as a colleague's machine was recently bricked on two different
> occasions after the kernel oopsed. The config option would simplify
> things a bit for us, though we could always carry a patch changing the
> default value.

Not sure why a command line option would be a more natural solution to
this problem? The original patch looked fine to me. All other pstore
backends are guarded by Kconfig options.

Though I could see an argument for a kernel parameter to turn off the
EFI pstore backend code, even if it's compiled into the kernel. But that
would be better as an additional patch.
