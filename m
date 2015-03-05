From: joeyli <jlee@suse.com>
Subject: Re: [PATCH v2 04/15] x86, kaslr: get kaslr_enabled back correctly
Date: Thu, 5 Mar 2015 10:58:09 +0800
Message-ID: <20150305025809.GA28401@linux-rxt1.site>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
 <1425456048-16236-5-git-send-email-yinghai@kernel.org>
 <20150304101649.GA3663@pd.tnic>
 <alpine.LNX.2.00.1503041652550.26925@pobox.suse.cz>
 <CAE9FiQU=wCmGEKoq06EV=oi=xxYwh7FGMEt7XiiPwrOLVo1OrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQU=wCmGEKoq06EV=oi=xxYwh7FGMEt7XiiPwrOLVo1OrA@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

Hi Yinghai,

On Wed, Mar 04, 2015 at 10:12:58AM -0800, Yinghai Lu wrote:
> On Wed, Mar 4, 2015 at 7:54 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> 
> >
> > Also this 15-patch series needs to be separated into two patchsets. The
> > whole series is not appropriate for -rc3, but this particular one at least
> > is a regression fix that has to go in.
> 
> The first 4 should go v4.0.
> 
> could leave others to v4.1
> 
> Thanks
> 
> Yinghai

After 84c91b7ae merged to v3.17 kernel, hibernate code checks the e280 regions
should not be changed when doing hibernate resume. Without your patch 8,
the hibernate resume checking will randomly fail on the machines that reserved
setup_data in e820 regions.

Could you please consider to put "[PATCH v2 08/15] x86: Kill E820_RESERVED_KERN"
to v4.0 kernel?


Thanks a lot!
Joey Lee
