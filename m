From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v2 02/15] x86, boot: move ZO to end of buffer
Date: Fri, 6 Mar 2015 14:58:25 +0100
Message-ID: <20150306135825.GE4259@pd.tnic>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
 <1425456048-16236-3-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425456048-16236-3-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 04, 2015 at 12:00:35AM -0800, Yinghai Lu wrote:
> bp found data from boot stage can not be used kernel stage.
> 
> Actually those data area is overlapped with VO kernel bss stage, and clear_bss()

"VO kernel bss stage"?

I'm sure you can think of a better explanation. Right now I'm thinking
of "Video Only" or "Virtually Omnipresent" or ... I can go all day.
Let's be more precise here please.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
