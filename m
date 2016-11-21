From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/16] efi: Get the secure boot status
Date: Mon, 21 Nov 2016 11:52:01 +0000
Message-ID: <CAKv+Gu-frVDhzORDRZ6XT+FxewsTgrxhXmM=DqaS6Ns4mJhQ9g@mail.gmail.com>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <147933285147.19316.11046583275861569558.stgit@warthog.procyon.org.uk>
 <20161117123731.GA11573@wunner.de> <29779.1479728545@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <29779.1479728545-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linn Crosetto <linn-ZPxbGqLxI0U@public.gmane.org>
Cc: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(+ Linn)

On 21 November 2016 at 11:42, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Lukas,
>
> Looking in efi_get_secureboot(), is there a reason:
>
>         efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
>
> isn't static const?
>

Not a good one, no. It used to be static const, but for some reason,
commit 30d7bf034c03 ("efi/arm64: Check SetupMode when determining
Secure Boot status") removed the static and the const (and I reviewed
it and did not complain AFAIR)
I'll gladly take a patch that reinstates that, though.
