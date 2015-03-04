From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH v2 04/15] x86, kaslr: get kaslr_enabled back correctly
Date: Wed, 4 Mar 2015 16:54:33 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1503041652550.26925@pobox.suse.cz>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org> <1425456048-16236-5-git-send-email-yinghai@kernel.org> <20150304101649.GA3663@pd.tnic>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150304101649.GA3663@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 4 Mar 2015, Borislav Petkov wrote:

> On Wed, Mar 04, 2015 at 12:00:37AM -0800, Yinghai Lu wrote:
> > commit f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
> > is using address as value for kaslr_enabled.
> > 
> > That will random kaslr_enabled get that set or cleared.
> > Will have problem for system really have kaslr enabled.
> > 
> > -v2: update changelog.
> 
> This is still not good enough. Please do this:
> 
> In commit f47233c2d34f we did A. The problem with that is B. Change the
> code to do C.
> 
> Now you only have to fill out the A,B and C variables with the
> respective text which is understandable even for people who don't know
> this code.

Also this 15-patch series needs to be separated into two patchsets. The 
whole series is not appropriate for -rc3, but this particular one at least 
is a regression fix that has to go in.

Thanks,

-- 
Jiri Kosina
SUSE Labs
