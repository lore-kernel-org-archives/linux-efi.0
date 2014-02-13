From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] firmware/efi : use NULL instead of 0 for pointer
Date: Thu, 13 Feb 2014 11:06:25 +0000
Message-ID: <20140213110625.GD20717@console-pimps.org>
References: <2817765.zrQqrE3135@daeseok-laptop.cloud.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2817765.zrQqrE3135-yEt5tssq++YB2AIH5/lADM23vB8/Nvlt@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daeseok Youn <daeseok.youn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 13 Feb, at 06:54:48PM, Daeseok Youn wrote:
> From 1c70573009a3b50cef2acaae1e5a8cd350edfe6d Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Thu, 13 Feb 2014 17:16:36 +0900
> Subject: [PATCH] firmware/efi : use NULL instead of 0 for pointer
> 
> following sparse warnings:
> 
> drivers/firmware/efi/efivars.c:230:66: warning:
>  Using plain integer as NULL pointer
> drivers/firmware/efi/efi.c:236:27: warning:
>  Using plain integer as NULL pointer
> 
> Signed-off-by: Daeseok Youn <daeseok.youn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c     |    2 +-
>  drivers/firmware/efi/efivars.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

This patch doesn't apply because it is corrupt,

  fatal: corrupt patch at line 11
  Patch failed at 0001 efi: Use NULL instead of 0 for pointer

Please attach the patch in a reply.

-- 
Matt Fleming, Intel Open Source Technology Center
