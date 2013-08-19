From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/4] EFI boot stub memory map fix
Date: Mon, 19 Aug 2013 14:39:38 -0700
Message-ID: <CAE9FiQVXMo5NSD4M47+z4N2fN+5dA1E1JKqQPh9ehzBdhgFARQ@mail.gmail.com>
References: <1376942419-5684-1-git-send-email-linn@hp.com>
	<e7fc4e2f-4cda-4eef-8d37-bb87773f58e8@email.android.com>
	<CAE9FiQWRp+AMeTnC3MPSWi4as6qaoFiZEsAfjr3+75YT9XMPcQ@mail.gmail.com>
	<20130819210939.GJ14273@oranje.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130819210939.GJ14273-QpTgeCMhooRo/CpIj0byZw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jacob Shin <jacob.shin-5C7GfCeVMHo@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 19, 2013 at 2:09 PM, Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org> wrote:

> One complication with SETUP_E820_EXT is in
> determining the size needed, since a call to allocate_pool will change the
> memory map.

second try or while loop could handle that.

Yinghai
