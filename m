Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794850652;
	b=YEUMpQOfN2aNt63LCfX6QEaIixvYHCl47QJob8E2vorMoVawTp8hhmK7tOTZOViGtluD
	 EDASvJCHrB1MxqVmuGD0d4JNM6eTsHpuUv0sYfnlHGPA4yFZ+wWm3eZC+MgsxufiPCrOk
	 ztni2wccw3E1isTtBUzzeyjHBBL7RepUsm1g1vQGsMugoiczD079Ux+JcyKa266vyGHen
	 bQrWBhK7IEa1WSNVdy7EdQByz9BJ7o0J9s8eoIVDY4txLwvWXmW4PSTOgGfXEhZjakGIR
	 7rA+q2TgtmVtxpmBovL/l22eWwAVRXkU3YfVFXm+VuEmOWqDkSaC8BNH4bu60TaFE0w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794850652;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
	b=4+sU6oF+Ym117C+/euGnISZcy2gUxL8cSe32AiZJyqtqVEIoBivcbeedVHU7+nCk6YtH
	 c8o/HVkkqDqUEokrXzkFoxX52VtkjNuSYEz4DoxaR0TG8iEdr1fjK1ZKIWsZlRpvpeStQ
	 ZcaARAYIyW3ROWLxDRZgFToTICubz2iNJhJwJVSP2rjVMUt/SIX+TJ2yMZ/S5ZGmzQ0Hf
	 Pe7xFw46JABkxNC+W6C6UGRy8z78KRd3Rl6D2uZLO+G4nM3acgQIvA82kJHSPPY2TWVo8
	 ySHCsMaLaUx5kwJkR9WUwA5EipKDmPUkGmWSGuzKtJc9/IQVdSOUx7LfIAcyF1o405g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wda5m4T+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3108A606A885
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 17:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3108A606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wda5m4T+
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b7245ab5e2so105382a12.1
        for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 09:37:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794850648; cv=none;
        d=google.com; s=arc-20260327;
        b=N2XhMKd4KDYD2fR3mY1cjWRVEGED3YE2NhhVemhFdZMruPDRgM+OyVEjfX8cQlvB7k
         RdFOQWdwjtR6MiyTSTIsYSQuifPqubO0K4NAOTGtoYQ6uOrVfnZ5zM4v2OLRLzzmXqfa
         5shhmPKWGAwUFTqgRTBy4TlwbBLhOuIJyyVkV7FKgFbdSNn/CnfIEYRqZkHtJkakKD3N
         ekkdY6DEfZoKl1EnubQDqZohR0vgqHgclShTQF0BXxHiDRQXSWb7/1Hl4rOlyDFd3Nko
         +wughc8EhvuvUrkdZq7MZX9J+o7cDv9dRZnmDkFKNgkMkMcPDifTpVQJUFqa1NtOhciF
         Yygw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        fh=dIjV73xz2qmsSMsvGKv0oWiyDbaplU/5KA4cVmkon5Q=;
        b=in3D+9SCw5dZU3mn0J3lNPdhJU9/ogPQpcs9DIq2bnqInmu7zHkALTpuDvIyyAEsAC
         maKpPEZ9OU0wSGalS64zfgkQRHg4e07GHpjSu9onBhVDipACkPhCrFPlJDnixlWqiwp9
         xpqVXqPVln7zPz3IvAVQqDkmQDWkXHh4Reydvoshdd0kSCs4H1gHJlHaFnjnuWwChwxI
         yrJUOtQbJS+wNHmCRwxI0l2AYvL75ebsHz11QRta8vvyiJiQ3tB2uQy0LWSEKZWud8Ms
         GBq6PXfbA2AYlyeOiCTh0kUmYxKkVCb2J5hIsUg90fp/CGMvalcUIkQQmRnzT14AhZcs
         /rOA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794850648; x=1795455448; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        b=Wda5m4T+Og74YNLartpajMnAcctT7hnb5haqi9hjLlBRa67TYcEPjf80gw45qsgIx7
         FMobW/aC2ZXQsUmoaLilVLeaESS9ODytholTX6ZkGdI39Z50BqAMQuVm0upEGdU/eTIl
         KzXBiwaEJY7eqa6p49n+ZePGE0YUDeVtz78JPQJb7w7ae3zRsyAfYOAEtJq8eS6befDe
         ANfoXo4rOnrr9cTK5CEQbvEa19yD1CMimOfBL7pxwr0U+pGpN6RB970vgsC2xV+kB6BG
         DqloDFELm5xz1LM2zdKvbUwHIwogDmvmrNVDo81Was00uh+K9TR8cjrFQWZvFUjBWrt9
         3Csg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794850648; x=1795455448;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        b=ff1weSCEHZTakiXKPPceoxW7MMxEgm9FOUuaNMw0Ke4fB7mSw0bvL8C8SpFgwdRek1
         yFV2WUMRIjtNTOSaDo8tCIvrpo4p7EUApGiK2Pt/MutGGin57b+/HHFU3P9Qyqx9FZYa
         3kIli4YNQ7QJ2zVJfJ0/Ohj5kGt1x4Nk1tg3cTdstybkZ5Q1t1A9rV+mqsl1NNtmhn0b
         XFTdJrr0kNPK9ZRXyZcHUxg1Gbr/QSRNI+UKgrYA73E2y1sJsBp8cxYhZLrEkxKZX3Mo
         14fIAsaLPREFak9wogrPSxStD+/UehicUZplpqb2wUt0Jdw9UYbYrw+4jjJGmV/3bcVW
         Byjg==
X-Forwarded-Encrypted: i=1; AL+hErFo/UpWO1njQQUMtcKkfo/IxXiEpcOQERYcgisw4J8HQ5GXFC05tpQ0AWxYCbcXDkSDb4VHvvZ61kk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+3FRou3JPxesPauHlyUY3vMXEw90KGk/o2GlGCT02z6kPrrPYp
	Q21X6zYsZp3EAKi2vRI8jNbjIHx4Vvhk3VQQoGbeuZWNZMvlF6ercoFUn9XFGCLKtj5CbVudG1P
	U4B2JhjDhS03XjJQsRV1Lo+mwtKJuZjg=
X-Gm-Gg: AYBFou1iyOv1C0QQJDhOUs+9SkzdHg9cS/d5GoeF2lYtqkOvMfteSGYw73CibDeDJCg
	85hoj4fTUaRnqSBUrY2AE8KxgkQ9QtWarXJ6xnSrutVyB7HOqQo2JtqAmeKhnkYmJcZ8ThAYaVF
	Y7voCfh6eh1A/Cg42MoehLrbAVfpiJlp8Yw+4e8K98C7+bdlpO4VfKb7KN8Uco+iki7jXPwkhVW
	s6ECHUs5h8OjdwfFWeiUW7p7KdOoHnNDibsFzcTAZ8b+BnGpVcuCaa51Sk/sj/1amRhuOb0KV9Y
	rTAkycdwSDtbNBsT2nPVrzbI3CghuI7LgfK5L7D2A+pIjJnqSLFkIsOXbZ50xdBp/mEJiyewjNR
	9O83hwIeM0EV+tpSwEBA/h/O2e1PIihzsN6B5p/+aQii3ZBUvpPiFoKbQ0vfGnM4qw3GhZg==
X-Received: by 2002:a05:6402:1598:b0:6b5:7250:d621 with SMTP id
 4fb4d7f45d1cf-6b859ae1a00mr134291a12.15.1794850647426; Mon, 16 Nov 2026
 09:37:27 -0800 (PST)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Nov 2026 18:37:16 +0100
X-Gm-Features: AclHuK_sKnxFPAK3k65pZhjyZC94SJD4eZ9z2j_P12s3kyb9TMw6hurQcjyq55Q
Message-ID: <CAOQ4uxgPerkkG4ie0SyHVXaBD9VZN2wYfQpEAEi4hytn=ara3A@mail.gmail.com>
Subject: Re: [PATCH RFC v3 33/44] ovl: refuse data-only layers on pseudo filesystems
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 12:10=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> The data of a metacopy file can live in a data-only layer. overlayfs
> doesn't look that data up when it looks up the file. It only remembers
> the absolute redirect and looks up the data lazily the first time
> someone needs it. So until then nothing can tell which filesystem holds
> the data of such a file.
>
> But a data-only layer has no business being a pseudo filesystem in the
> first place. All it does is hold the data of metacopy files and the
> regular files of a pseudo filesystem are kernel interfaces, not storage.
> So let's refuse data-only layers on superblocks with SB_I_PSEUDO at
> mount time.
>
> Data-only layers can be added via the "::" separator in "lowerdir=3D" and
> via "datadir+" by path or by file descriptor. All of them end up at the
> end of ctx->lower. So a single check in ovl_get_lowerstack() covers all
> of them.
>
> Note that regular lower layers on pseudo filesystems are left alone.
> Stacking overlayfs on top of sysfs keeps working.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo=
91QjJHH9T_Yw@mail.gmail.com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/overlayfs/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 39d4d57dec230..719c2569dfeaf 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1237,6 +1237,14 @@ static struct ovl_entry *ovl_get_lowerstack(struct=
 super_block *sb,
>         for (i =3D 0; i < ctx->nr; i++) {
>                 l =3D &ctx->lower[i];
>
> +               /* Pseudo filesystems don't hold data for metacopy files.=
 */
> +               if (i >=3D ctx->nr - ctx->nr_data &&
> +                   (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
> +                       pr_err("filesystem on %s not supported as data-on=
ly layer\n",
> +                              l->name);
> +                       return ERR_PTR(-EINVAL);
> +               }
> +

How about we make this just a tad more restrictive:

                /* Pseudo filesystems don't belong in composefs setup */
                if (ctx->nr_data &&
                    (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
                        pr_err("filesystem on %s not supported along
with data-only layers\n",
                               l->name);
                        return ERR_PTR(-EINVAL);
                }

I could send this as followup patch, but since this version is simpler
there is no real reason to have the intermediate "only ban datadir" step.

Only the commit message needs a little more flexing to justify this.

Thanks,
Amir.
