From: "Lad, Prabhakar" <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Trivial patch in efifb.c to solve common indent issue and
 indent error
Date: Mon, 9 Feb 2015 14:24:50 +0000
Message-ID: <CA+V-a8todzzHHTSaJ1UzT+1sXrdbNaaBah66gFr2kEigNBhQYw@mail.gmail.com>
References: <20150209125548.GA27277@linuxteamdev.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150209125548.GA27277-uSknhY0EtF8ok8EplQz5xE1Vg53cnbg30E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
Cc: pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, LFBDEV <linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

Thanks for the patch.

On Mon, Feb 9, 2015 at 12:55 PM, Parmeshwr Prasad
<parmeshwr_prasad-8PEkshWhKlo@public.gmane.org> wrote:
> Hi All,
>
> Please review this patch.
> this patch is aimed to solve some indentation issue. It has also solved
> three trivial error in efifb.c file.
>
> And I have also changed printk with pr_err, pr_info ... at respective places.
>
>
> From c49139fac1d15fe2da80d06e2a79eb8be7c079a7 Mon Sep 17 00:00:00 2001
> From: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
> Date: Mon, 9 Feb 2015 07:33:59 -0500
> Subject: [PATCH] Trival patch: improved indentation, and removed some ERROR
>  from code
>
> Signed-off-by: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
> ---

1: did you use git to send this patch ?
2: did you checkpatch it (I see some issues)?
3: break this patch into 2 one fixing the 3 issues and other fixing
the indentation.
4: have proper commit message.

Cheers,
--Prabhakar Lad
