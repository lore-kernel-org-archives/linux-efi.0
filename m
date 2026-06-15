Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A3F3B6BF0;
	Mon, 15 Jun 2026 20:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781555254; cv=none; b=gjzUD6fyN976hSnGzOGrEfr5VwIY3Q7UtiimbNllmSC+ARFou6FP0uAeae/D8K+V5TS5/bK3Dg7skc92hhJahGsuJe7ROTP3P9236QDroRNGfQPCBf/DzNKDJo+fr1q7q4GuVX9xW5ssVpiwXhuMGE1Xo2WeTx5AnlFYU3vvRE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781555254; c=relaxed/simple;
	bh=qC5ROOrpLHI/uhOaofau2YtMk+bJjHJvYmfwn4TxoG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h2acC0nts2D189CHLp/nqU9ubnYwVje++4Sq9tGZrPX/6MGf4WrCwJD6coyYUKiYSRyxJ5fYXYlLClK5YeBKKjsY/oiwsV/NkRgaTuRdhjO10ZZkdyQ1Ip9tE0eCSHFnt7ZG5swoNGE8sN0gD9pBWiyy6jHRx5gX6UJ8T/mKFew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b=DCBrnOFA; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b="DCBrnOFA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1781555239; x=1782160039; i=deller@gmx.de;
	bh=cJsBQ+2dMsQHRf126Ew7m+GYdX1z6BAFUbWxSH6eLPE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=DCBrnOFAQkMjqFnQTPLra5rMOGXD874pekmBNIH1ivdrboNmay4ZwqdIvIpvxDvk
	 tmwd5DCYz75o8SR/vjmXK33UDZRrdUv8AjrhueV6SNnfETn8BOZO0tzQ3Y/JzU1LN
	 b9yVUfWhVbmLO2ch1IA6FhoNxMhoi3AWfrWKdzdZz/I8nmOu2mdXoWQNZ8RztV3v/
	 w3TQw442oSL2oJridq12KF3PNe5IFeIvDzFyasLy3klDdi7vC7LBwZCTh3aJxdTit
	 m6X6orMOuX52kop8cgIb6Eo9TpBT7ImSEq8BwG2087akaPxiHyixAACZyoYJPaGxG
	 DIyfqqyuUPxg+ke3ZA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MLzFr-1wr1tv2RWb-00LRg1; Mon, 15
 Jun 2026 22:27:18 +0200
Message-ID: <0290e66b-1da2-4706-ab28-2d47f164df08@gmx.de>
Date: Mon, 15 Jun 2026 22:27:16 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/19] parisc: define DPS root partition type UUID
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
 Vincent Mailhol <mailhol@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Davidlohr Bueso <dave@stgolabs.net>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-parisc@vger.kernel.org
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
 <20260615-discoverable-root_partitions-v1-8-39c78fac42e2@kernel.org>
 <0158c89cffd76c621607f66d1889ccc084754729.camel@HansenPartnership.com>
Content-Language: en-US
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 xsFNBF3Ia3MBEAD3nmWzMgQByYAWnb9cNqspnkb2GLVKzhoH2QD4eRpyDLA/3smlClbeKkWT
 HLnjgkbPFDmcmCz5V0Wv1mKYRClAHPCIBIJgyICqqUZo2qGmKstUx3pFAiztlXBANpRECgwJ
 r+8w6mkccOM9GhoPU0vMaD/UVJcJQzvrxVHO8EHS36aUkjKd6cOpdVbCt3qx8cEhCmaFEO6u
 CL+k5AZQoABbFQEBocZE1/lSYzaHkcHrjn4cQjc3CffXnUVYwlo8EYOtAHgMDC39s9a7S90L
 69l6G73lYBD/Br5lnDPlG6dKfGFZZpQ1h8/x+Qz366Ojfq9MuuRJg7ZQpe6foiOtqwKym/zV
 dVvSdOOc5sHSpfwu5+BVAAyBd6hw4NddlAQUjHSRs3zJ9OfrEx2d3mIfXZ7+pMhZ7qX0Axlq
 Lq+B5cfLpzkPAgKn11tfXFxP+hcPHIts0bnDz4EEp+HraW+oRCH2m57Y9zhcJTOJaLw4YpTY
 GRUlF076vZ2Hz/xMEvIJddRGId7UXZgH9a32NDf+BUjWEZvFt1wFSW1r7zb7oGCwZMy2LI/G
 aHQv/N0NeFMd28z+deyxd0k1CGefHJuJcOJDVtcE1rGQ43aDhWSpXvXKDj42vFD2We6uIo9D
 1VNre2+uAxFzqqf026H6cH8hin9Vnx7p3uq3Dka/Y/qmRFnKVQARAQABzRxIZWxnZSBEZWxs
 ZXIgPGRlbGxlckBnbXguZGU+wsGRBBMBCAA7AhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheA
 FiEERUSCKCzZENvvPSX4Pl89BKeiRgMFAl3J1zsCGQEACgkQPl89BKeiRgNK7xAAg6kJTPje
 uBm9PJTUxXaoaLJFXbYdSPfXhqX/BI9Xi2VzhwC2nSmizdFbeobQBTtRIz5LPhjk95t11q0s
 uP5htzNISPpwxiYZGKrNnXfcPlziI2bUtlz4ke34cLK6MIl1kbS0/kJBxhiXyvyTWk2JmkMi
 REjR84lCMAoJd1OM9XGFOg94BT5aLlEKFcld9qj7B4UFpma8RbRUpUWdo0omAEgrnhaKJwV8
 qt0ULaF/kyP5qbI8iA2PAvIjq73dA4LNKdMFPG7Rw8yITQ1Vi0DlDgDT2RLvKxEQC0o3C6O4
 iQq7qamsThLK0JSDRdLDnq6Phv+Yahd7sDMYuk3gIdoyczRkXzncWAYq7XTWl7nZYBVXG1D8
 gkdclsnHzEKpTQIzn/rGyZshsjL4pxVUIpw/vdfx8oNRLKj7iduf11g2kFP71e9v2PP94ik3
 Xi9oszP+fP770J0B8QM8w745BrcQm41SsILjArK+5mMHrYhM4ZFN7aipK3UXDNs3vjN+t0zi
 qErzlrxXtsX4J6nqjs/mF9frVkpv7OTAzj7pjFHv0Bu8pRm4AyW6Y5/H6jOup6nkJdP/AFDu
 5ImdlA0jhr3iLk9s9WnjBUHyMYu+HD7qR3yhX6uWxg2oB2FWVMRLXbPEt2hRGq09rVQS7DBy
 dbZgPwou7pD8MTfQhGmDJFKm2jvOwU0EXchrcwEQAOsDQjdtPeaRt8EP2pc8tG+g9eiiX9Sh
 rX87SLSeKF6uHpEJ3VbhafIU6A7hy7RcIJnQz0hEUdXjH774B8YD3JKnAtfAyuIU2/rOGa/v
 UN4BY6U6TVIOv9piVQByBthGQh4YHhePSKtPzK9Pv/6rd8H3IWnJK/dXiUDQllkedrENXrZp
 eLUjhyp94ooo9XqRl44YqlsrSUh+BzW7wqwfmu26UjmAzIZYVCPCq5IjD96QrhLf6naY6En3
 ++tqCAWPkqKvWfRdXPOz4GK08uhcBp3jZHTVkcbo5qahVpv8Y8mzOvSIAxnIjb+cklVxjyY9
 dVlrhfKiK5L+zA2fWUreVBqLs1SjfHm5OGuQ2qqzVcMYJGH/uisJn22VXB1c48yYyGv2HUN5
 lC1JHQUV9734I5cczA2Gfo27nTHy3zANj4hy+s/q1adzvn7hMokU7OehwKrNXafFfwWVK3OG
 1dSjWtgIv5KJi1XZk5TV6JlPZSqj4D8pUwIx3KSp0cD7xTEZATRfc47Yc+cyKcXG034tNEAc
 xZNTR1kMi9njdxc1wzM9T6pspTtA0vuD3ee94Dg+nDrH1As24uwfFLguiILPzpl0kLaPYYgB
 wumlL2nGcB6RVRRFMiAS5uOTEk+sJ/tRiQwO3K8vmaECaNJRfJC7weH+jww1Dzo0f1TP6rUa
 fTBRABEBAAHCwXYEGAEIACAWIQRFRIIoLNkQ2+89Jfg+Xz0Ep6JGAwUCXchrcwIbDAAKCRA+
 Xz0Ep6JGAxtdEAC54NQMBwjUNqBNCMsh6WrwQwbg9tkJw718QHPw43gKFSxFIYzdBzD/YMPH
 l+2fFiefvmI4uNDjlyCITGSM+T6b8cA7YAKvZhzJyJSS7pRzsIKGjhk7zADL1+PJei9p9idy
 RbmFKo0dAL+ac0t/EZULHGPuIiavWLgwYLVoUEBwz86ZtEtVmDmEsj8ryWw75ZIarNDhV74s
 BdM2ffUJk3+vWe25BPcJiaZkTuFt+xt2CdbvpZv3IPrEkp9GAKof2hHdFCRKMtgxBo8Kao6p
 Ws/Vv68FusAi94ySuZT3fp1xGWWf5+1jX4ylC//w0Rj85QihTpA2MylORUNFvH0MRJx4mlFk
 XN6G+5jIIJhG46LUucQ28+VyEDNcGL3tarnkw8ngEhAbnvMJ2RTx8vGh7PssKaGzAUmNNZiG
 MB4mPKqvDZ02j1wp7vthQcOEg08z1+XHXb8ZZKST7yTVa5P89JymGE8CBGdQaAXnqYK3/yWf
 FwRDcGV6nxanxZGKEkSHHOm8jHwvQWvPP73pvuPBEPtKGLzbgd7OOcGZWtq2hNC6cRtsRdDx
 4TAGMCz4j238m+2mdbdhRh3iBnWT5yPFfnv/2IjFAk+sdix1Mrr+LIDF++kiekeq0yUpDdc4
 ExBy2xf6dd+tuFFBp3/VDN4U0UfG4QJ2fg19zE5Z8dS4jGIbLg==
In-Reply-To: <0158c89cffd76c621607f66d1889ccc084754729.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ynOhvwPKXe+gPrQUltx2IShzBuxZFEwvw/BdMV+DKo0J+sSHy0j
 Skx/Akxpjt8aVvWy1+6huOv0JDjdKWJyENllOL6NkuBPnkWtY/LMZV1IVyPyeaHhSN6+djW
 4inN8bHZn16KT5D6Oc7iVFoGPHSWasP/j5o+ivtUDnbv+hb92E1nAxLK6DcO+Fm6fI/RNMo
 sRGuUnxvF11dsmFU7iA6w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:HoSgat8W9Nw=;FsfXI6+Tpv7zlN37KWDqmDzEOzh
 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
 bOqMmw==

On 6/15/26 22:02, James Bottomley wrote:
> On Mon, 2026-06-15 at 18:09 +0200, Vincent Mailhol wrote:
>> DPS [1] assigns GPT partition type UUIDs to operating system
>> partitions. Root partitions use architecture-specific type UUIDs so
>> the OS can discover the intended root filesystem without relying on a
>> root=3D  cmdline option.
>>
>> Define DPS_ROOT_PARTITION_TYPE_UUID in asm/dps_root.h for parisc and
>> select ARCH_HAS_DPS_ROOT_PARTITION_TYPE_UUID.

Vincent, first of all thank you for at least trying to including parisc (a=
nd other
niche Linux ports) in the specification! (whatever the outcome is!)

>> [1] The Discoverable Partitions Specification (DPS)
>> Link:
>> https://uapi-group.org/specifications/specs/discoverable_partitions_spe=
cification/
>=20
> How are you planning to make this work for parisc?  Some systems have a
> PALO boot partition (fdisk type 0xf0) but the more modern way is to
> place palo inside a hidden ext4 inode in /boot.  The way parisc IODC
> works is very similar to the way MSDOS boots with the palo location
> table in the first block so I theorize that would probably work for gpt
> partitions as well ... I'm just not sure anyone has tested it.
>=20
> However, to get this to work with PALO for auto discovery, you'd need
> palo patches to recognize the DPS UUID and no-one seems to have
> submitted anything to palo for this.

Maybe it's not necessary that palo does this job?
palo could stay as is and load kernel and the initrd.
Then the kernel (or the scripts in initrd) could try to find the root
partition on it's own (and handle GPT discs).

I even once started porting grub to parisc (which is currently on hold
because I'm busy with other stuff). If I ever finish it, having such a
mechanism/constant already in place is IMHO beneficial.

Helge
