Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793656024;
	b=HnQxvjqf2+rrKi/0NKoVU/zG7L5TC+86KCtyMmDcNPfbe8ARlyLxpVadU12aTInpdBhs
	 hgBuYqFcGaWoK+Cc1LmjwFG6fOLTKqganasf6V7nsCLLiPfHfq2eSt3wE1stCXhzSVVLP
	 4ussMV2Zb2JBjbDB3jtK/mj1IxTXNoMMGd0Aa7P0CPa3GUIG3Yk9Bacy6ThYiYvKi7Ln2
	 kErQnCJ2wsvbR5HtvepjzkoftTm2beJRUA+QSBw7iGkFWRBp4kr4+Q4JYx1Sv7ZBBuXhu
	 yiI7vQCyVkxFz8x5vNiE3Vqct3ahaoN9fXW+F43KIysRd2PRzbO+GyL6PeduDq8BVUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793656024;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QPZgK+2ggTjV2BZHpoUXBwscjutTkEWYEQcx8WgyZH0=;
	b=TEEH7blDuWi6g5tsS4qmmgo03BLT6jCEQkQc1KdI9w0rB8/Ed4tyW5T88Kils60/+2oe
	 VuGLLik62enU0s/SOBt0FWgnA+U2LjcN6irRoJrybnJ2EpTGRhEO9+hkWN1/DU57r3yQT
	 e+m7Xcnb/8GyS6istqcGj7Ykdxwqy1CBzDqLyU3OqyIV08b2vYNLsAVgZJTqlGTyg+fod
	 +P+laDxaDhPOCSeyymgkart9h7PZFNjiPESZUNn/pbesYY8D01GUpVxTIu0hYuENraP3L
	 XkeUwKaCMkP04nNJIPmRy16yyms2lILOqsAWBro1U53ElxS01hf/kwcqJ9cmYdiOBSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="HSSxJ/nJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461C9606D806
	for <linux-efi@vger.kernel.org>; Mon,  2 Nov 2026 21:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HSSxJ/nJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5286F1F00A17;
	Mon,  2 Nov 2026 21:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793656023;
	bh=QPZgK+2ggTjV2BZHpoUXBwscjutTkEWYEQcx8WgyZH0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HSSxJ/nJipbAH9DLgYnA12V3CqksOXfgNrywpcb9r4NIPylmFuQFhZOTnLhJnMcXs
	 m4zMYoyvDfrNtkjj9DsjPMD29DVLbpFmVe9KmyzdSaDyxO4YR0N108iQFKdJr6zebl
	 aWYETmIYn02hKPDVM6G7525wXLP4eXHw/S6vWDf9CjyPf+F0FuwWdE1yAGF6jgT5+D
	 EwGoh9EGkz6Mg3SrEvOzOPQP21mcfF5L1fRvbU3KcC9mlx0VS6P6CYcp+VHPsaFPGO
	 rfOe+w1MhO3i7XYUWDO59vFtxb+EMBssVPubr3w92SNbCuf3F7jRsxX79UMwr7UmNK
	 7fXXPJLPrg+TQ==
Message-ID: <sashiko-outbox-194234@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 4/7] block: discover root by DPS partition type UUID
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Mailhol" <mailhol@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "Davidlohr
 Bueso" <dave@stgolabs.net>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>
Cc: linux-efi@vger.kernel.org, "Dave Hansen" <dave.hansen@intel.com>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Helge Deller" <deller@gmx.de>, "Matthew
 Wilcox" <willy@infradead.org>
In-Reply-To: <20261102-discoverable-root_partitions-v3-4-27f04b69b7ab@kernel.org>
References: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>
 <20261102-discoverable-root_partitions-v3-4-27f04b69b7ab@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 21:47:02 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] init: unconditional DPS discovery in prepare_namespace() breaks no=
dev root
- [High] init: DPS root auto-discovery in lookup_root_device() rejected by =
maintainer
--

commit 810f32136ad63589849b2f0f1f1255fa412bff0c
Author: Vincent Mailhol <mailhol@kernel.org>

block: discover root by DPS partition type UUID

This commit adds root block device discovery using the architecture's
Discoverable Partitions Specification (DPS) root partition type UUID when
root=3D and ROOT_DEV are not set. It reads LoaderDevicePartUUID from EFI to
locate the disk containing the active EFI System Partition and searches that
disk for a matching root partition.

Link: https://uapi-group.org/specifications/specs/discoverable_partitions_s=
pecification/

> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index b0dccad209710..c1106e3cab3dc 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -406,10 +406,24 @@ static int __init lookup_root_device(const char *ro=
ot_device_name, dev_t *dev)
>  {
>  	int err;
> =20
> -	err =3D early_lookup_bdev(root_device_name, dev);
> +	if (root_device_name[0]) {
> +		err =3D early_lookup_bdev(root_device_name, dev);
> +		if (err =3D=3D -EINVAL && root_wait) {
> +			pr_err("VFS: root=3D is invalid; disabling rootwait.\n");
> +			root_wait =3D 0;
> +		}
> +		return err;
> +	}
> +
> +	err =3D early_lookup_dps_root(dev);

[Severity: High]
As reported by Christian Brauner on v1 [1], does in-kernel DPS root
auto-discovery belong in the kernel?

On v1 of this series, the VFS subsystem maintainer objected to adding DPS
auto-discovery to the kernel, noting that DPS is complex userspace policy a=
nd
should not be implemented in the kernel for root auto-discovery.

This patch still adds early_lookup_dps_root() in block/early-lookup.c and
wires it into prepare_namespace() -> parse_root_device() ->
lookup_root_device() in init/do_mounts.c when root=3D and ROOT_DEV are unse=
t.

>  	if (err =3D=3D -EINVAL && root_wait) {
> -		pr_err("VFS: root=3D is invalid; disabling rootwait.\n");
> +		pr_err("VFS: Root discovery is unavailable; disabling rootwait.\n");
>  		root_wait =3D 0;
> +	} else if (err =3D=3D -ENODEV) {
> +		pr_err("VFS: No discoverable root partition found; aborting.\n");
> +		root_wait =3D 0;
> +		*dev =3D 0;
> +		return 0;
>  	}
>  	return err;
>  }

[ ... ]

> @@ -480,7 +497,7 @@ void __init prepare_namespace(void)
> =20
>  	md_run_setup();
> =20
> -	if (saved_root_name[0])
> +	if (saved_root_name[0] || !ROOT_DEV)
>  		ROOT_DEV =3D parse_root_device(saved_root_name);

[Severity: High]
Does calling parse_root_device() unconditionally when saved_root_name is
empty and ROOT_DEV is 0 cause a regression for nodev root filesystems
(such as tmpfs, ramfs, virtiofs, or 9p) configured via rootfstype=3D without
root=3D?

Previously, when booting without root=3D and with rootfstype=3D specifying a
nodev filesystem, prepare_namespace() skipped parse_root_device() and left
ROOT_DEV as 0, allowing mount_root() to reach case 0 and call
mount_nodev_root():

init/do_mounts.c:mount_root() {
	switch (ROOT_DEV) {
	...
	case 0:
		if (root_device_name && root_fs_names &&
		    mount_nodev_root(root_device_name) =3D=3D 0)
			break;
		fallthrough;
	default:
		mount_block_root(root_device_name);
		break;
	}
}

With this change, prepare_namespace() invokes parse_root_device() ->
lookup_root_device() -> early_lookup_dps_root() before mount_root() checks
for a nodev rootfstype=3D.

If the system boots via EFI from a disk that happens to contain a partition
matching the architecture DPS root type UUID (for example, a VM or host disk
with an installed OS image booting a kernel with rootfstype=3Dtmpfs or
rootfstype=3Dvirtiofs and no root=3D), early_lookup_dps_root() sets ROOT_DE=
V to
that block partition. mount_root() then skips case 0 and enters
mount_block_root() instead of mount_nodev_root(), either hijacking the root
mount or panicking when the nodev filesystem rejects /dev/root.

Even when no matching DPS partition exists on the ESP disk (or when
LoaderDevicePartUUID is absent), early_lookup_dps_root() and
lookup_root_device() unconditionally log KERN_ERR messages such as:

	pr_err("VFS: No discoverable root partition found; aborting.\n");

or:

	pr_err("VFS: Unable to get EFI partition UUID: %pe, skipping root partitio=
n discovery\n",
		ERR_PTR(err));

right before mount_nodev_root() proceeds to mount the nodev root filesystem.

[1] https://lore.kernel.org/r/20260617-irritation-rollen-wirst-7d636cbfec92=
@brauner

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-discoverab=
le-root_partitions-v3-0-27f04b69b7ab@kernel.org?part=3D4
