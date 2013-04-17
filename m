From: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Subject: Re: [PATCH v2 0/6] Chainsaw efivars.c
Date: Wed, 17 Apr 2013 02:30:40 +0200
Message-ID: <CAG-2HqVBiSMp648F=zdUBDWQ49_a=rEPJ_TH__zWtaPSjju-KQ@mail.gmail.com>
References: <1366148520-29954-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366148520-29954-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

On Tue, Apr 16, 2013 at 11:41 PM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> This patch series introduces the new efivar_entry API, and splits out the major
> parts of efivars.c into new files. In particular, having the efivarfs code
> under fs/ allows building an efivarfs.ko module, which means mount(8) can
> automatically load it.
>
> The remaining EFI code is repositioned under drivers/firmware/efi/.

These all look good to me, so feel free to add my Reviewed-by.

Tested on top of 3.9-rc7, with everything built as modules. Everything
works as intended: systemd correctly detects it is on an EFI system,
so mounts efivarfs, which auto-loads the required modules.

Thanks a lot!

Tom
