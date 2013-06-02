From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
Date: Sun, 2 Jun 2013 23:56:20 +0100
Message-ID: <20130602225620.GA5496@srcf.ucam.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370177770-26661-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>, X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

I've just run Windows 8 under a hacked up copy of OVMF that dumps the 
data passed to SetVirtualAddressMap. It seems that Windows *is* mapping 
the runtime services to higher addresses - so presumably the 1:1 mapping 
is in addition to the virtual mapping.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
