From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode V2
Date: Thu, 18 Apr 2013 23:00:27 -0700
Message-ID: <bb2db2a1-835f-47d0-830d-0dd3785343a9@email.android.com>
References: <1366236341-22615-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <20130419055813.GA16443@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130419055813.GA16443-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Cc: matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The only real use for command line options is to be able to get users to test something during troubleshooting.

Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:

>On Wed, Apr 17, 2013 at 11:05:41PM +0100, Bryan O'Donoghue wrote:
>> Some EFI BIOS stores BGRT data in the wrong place and some EFI based
>> BIOS also requires mapping of boot code/data when doing
>> efi_enter_virtual_mode.
>> 
>> Current code in efi_enter_virtual_mode maps both EFI_RUNTIME_MEMORY
>and
>> BIOS boot code/data.
>> 
>> This patch gives the option to switch off that behavior - if your
>BIOS
>> has neither BGRT - nor bugs that require mapping of EFI boot
>code/data
>
>No, never add new boot options, no users, or distros, know to set them.
>Isn't there some way we can dynamically determine this instead?
>
>thanks,
>
>greg k-h

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
