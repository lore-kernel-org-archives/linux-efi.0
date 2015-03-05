From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2 04/15] x86, kaslr: get kaslr_enabled back correctly
Date: Wed, 4 Mar 2015 19:20:15 -0800
Message-ID: <CAE9FiQWa13Z1Eixwsjku5X_CxLpfSk+QFCOooC59YeH7dAqHgA@mail.gmail.com>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
	<1425456048-16236-5-git-send-email-yinghai@kernel.org>
	<20150304101649.GA3663@pd.tnic>
	<alpine.LNX.2.00.1503041652550.26925@pobox.suse.cz>
	<CAE9FiQU=wCmGEKoq06EV=oi=xxYwh7FGMEt7XiiPwrOLVo1OrA@mail.gmail.com>
	<20150305025809.GA28401@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20150305025809.GA28401@linux-rxt1.site>
Sender: linux-pci-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 4, 2015 at 6:58 PM, joeyli <jlee@suse.com> wrote:
>
> After 84c91b7ae merged to v3.17 kernel, hibernate code checks the e280 regions
> should not be changed when doing hibernate resume. Without your patch 8,
> the hibernate resume checking will randomly fail on the machines that reserved
> setup_data in e820 regions.
>
> Could you please consider to put "[PATCH v2 08/15] x86: Kill E820_RESERVED_KERN"
> to v4.0 kernel?

That will trigger SETUP_PCI ioremap warning.

That is the reason I want to put it with other setup_data fix.

Thanks

Yinghai
