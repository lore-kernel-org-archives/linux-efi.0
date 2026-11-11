Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794410681;
	b=F2co37cB6rrPkBJCNQ9Ior1vOasPiVSY6OFqnPwPq5St9Toj98UpVn9+A6SjAEqiFUU9
	 soKEkIT4cjeSuc2+hpPjwql1mrmS8V0/t0q48viodFMMdNvFhnjMPIW2nB48EFGOC6fCL
	 pxgm1nyBJRuMKzV0tNBk6Q6l1okXMW6UgmUftiG83uY05SYXuI3i6PO4oW+fAUlWBs9rZ
	 +Mz91bmI/aNac0bVZt8sYiyCkg0MUXMo0jJA2SCx/0xfg6IvqXmexQcnNKM4+T9qbigcG
	 ZaAK+6zZ9GBraJ2l4THjqNQ4dMZFMMN+uSk3q4Y765VpuuOqiROhSnCmQqrHJ4Kqmhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794410681;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=7rlJEv9evoBI2KAjTlHLGZOiwbHI0+oY97L62l2xy8o=;
	b=lyd1r+GL1bj6DBXXkR9ZnR0rhpd8HwaheBqz73VqwJ5+bFu4G4OTDVQVqoI7RQTLjWIm
	 hDQZ303F3MllQLB9vx5aPq/4vbsegTkjKfUGelMqWrcTa/gJXHncN6LlMz8LrLxH8om8S
	 ZoqS921ENWiZyLnSFbHLE9TnNSNlxeL5wHqoSlJzPgQLcjiYiktwbVhmEpWYCUP2SyXXE
	 jB8PQ5IiPY6IYiaOs1gByNzfzRir5RoHJnqEDeb+FNohaZTOpb8kzrZjYyFzSU9hoNzXn
	 GizOt6PXcf4Jm1U8f3FJ/6mueDdNOhnU+DuRZbekgnHoxg4N46Dvc6uYRpbEXrvwPpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UP0WtOTS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0244B606A321;
	Wed, 11 Nov 2026 15:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UP0WtOTS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E171F00A06;
	Wed, 11 Nov 2026 15:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794410680;
	bh=7rlJEv9evoBI2KAjTlHLGZOiwbHI0+oY97L62l2xy8o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UP0WtOTSWMqKEZDXuJZiTJAE6wRoWBDo1pbT4VRCMFyZWqITM3/tzSpcGU22ySLk0
	 Twf5YoC8ENgWXKEuA0hnf6q4YbCOx2OAVAIYzYrJqpAlt2bOGsT2J4yDKth6tNnymm
	 B+r409xvxfyqXGh8eG99Vm8M2BVAWvm1uLlE2ntQO6dZbPPKpyEm6HhAH2fYbJO5lq
	 CsPJg/rbWWYjTfbwqlShW+gqYEv5NQGYbvqdFKnxFrfnY91BG0gsxotesYonbwKUHQ
	 U/oUp3lcvFJF4W835IEEYpOcStF7CJpHDSOPzYEWoGg64AhMduzX8uIzGPQ790cmVQ
	 I+qMUbEIiZ41A==
Message-ID: <182e7cc2-43cd-4858-99ca-5f243e2c9eb5@kernel.org>
Date: Wed, 11 Nov 2026 16:24:35 +0100
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] init: discoverable root partitions
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Davidlohr Bueso <dave@stgolabs.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Dave Hansen <dave.hansen@intel.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Matthew Wilcox <willy@infradead.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
References: <20261102-discoverable-root_partitions-v3-0-27f04b69b7ab@kernel.org>
 <20261110-fachlehrer-anhaften-unkenntlich-86fc48b56f8f@brauner>
From: Vincent Mailhol <mailhol@kernel.org>
Content-Language: en-US
Autocrypt: addr=mailhol@kernel.org; keydata=
 xjMEZluomRYJKwYBBAHaRw8BAQdAf+/PnQvy9LCWNSJLbhc+AOUsR2cNVonvxhDk/KcW7FvN
 JFZpbmNlbnQgTWFpbGhvbCA8bWFpbGhvbEBrZXJuZWwub3JnPsKZBBMWCgBBAhsDBQsJCAcC
 AiICBhUKCQgLAgQWAgMBAh4HAheAFiEE7Y9wBXTmfyDldOjiq1/riG27mcIFAmrTM8wFCR1O
 HxcACgkQq1/riG27mcJ2KAEAhG19xBSkjiA9dtatvq2WJnGaes4SUmY+LSn7dh1Lf7YBAIwB
 lsMMmigMTk3Qgwymg1nT+Z8z1Owc/TGtRlo4ZcwMzjgEZx4y8xIKKwYBBAGXVQEFAQEHQJrb
 YZzu0JG5w8gxE6EtQe6LmxKMqP6EyR33sA+BR9pLAwEIB8J+BBgWCgAmAhsMFiEE7Y9wBXTm
 fyDldOjiq1/riG27mcIFAmrTNKcFCRUFdT0ACgkQq1/riG27mcLEVwD/VmnQtTf6yhowaIFj
 AjUtwiyQz9ja4NRu9GOvz/pb2L8A/3QcADR0dcxADGsmOiBpN2M9KI7nqdNIq3VPM/3/5fcB
In-Reply-To: <20261110-fachlehrer-anhaften-unkenntlich-86fc48b56f8f@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/11/2026 at 17:03, Christian Brauner wrote:
> On Mon, Nov 02, 2026 at 10:29:07PM +0100, Vincent Mailhol wrote:
>> This series adds root discovery directly into the kernel so that people
>> who are not using an initrd can still benefit from it.
> 
> Nothing has changed since
> https://lore.kernel.org/r/20260617-irritation-rollen-wirst-7d636cbfec92@brauner

I replied to your earlier message to explain my position but did not
hear back.

Since v1, I have rewritten the cover letter to better explain why I
think implementing a subset of DPS in the kernel makes a
difference. The relevant paragraph is:

  This is useful for booting a kernel manually, for example from the edk2
  file browser, or recovering from a lost or corrupted bootloader
  configuration without having to supply the correct root= argument or
  load an initrd from the bootloader shell. Finally, it allows systems
  that otherwise need no initrd to discover their root partition through
  DPS without introducing an early userspace environment solely for that
  lookup.

Similarly, I clarified the scope to address your concern about the
complexity of DPS:

  The scope is deliberately limited to block devices that the kernel can
  already mount through the root= parameter. Other DPS features, such as
  setting up LUKS-encrypted partitions, mounting partitions other than
  root or container setup, remain userspace responsibilities, with no
  future plan to implement them in the kernel. The intended usage is
  thus a hybrid approach in which the kernel DPS only mounts the root
  partition and leaves the remaining setup to userspace (either with DPS
  or with a classic fstab), just as it does today when root= specifies
  the root device.

I would appreciate hearing whether these use cases and the limited
scope address your concerns.


Yours sincerely,
Vincent Mailhol
