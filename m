From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efivarfs: loosen restriction on valid names
Date: Thu, 07 Mar 2013 15:09:15 +0000
Message-ID: <1362668955.15011.204.camel@mfleming-mobl1.ger.corp.intel.com>
References: <5138ACFE.30701@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5138ACFE.30701-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-03-07 at 16:06 +0100, Maarten Lankhorst wrote:
> Commit da27a2438 (efivarfs: guid part of filenames are case-insensitive) fails to boot,
> because the kernel creates files in the form of dump-type-x-y-z-GUID. Since the kernel already
> created files in this form, these type of files obviously exist, so the right course of action
> is to relax the restriction in efivarfs_valid_name.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [3.8]

http://marc.info/?l=linux-kernel&m=136266857528382&w=2
