Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E5E3B47D3;
	Mon, 15 Jun 2026 20:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781554786; cv=none; b=tHW6He1yrH+OFmtvvQZAEHd7KdPeQyfmsqwr/qFsPekGk0wwBdwcK6J6tN9FwviaZztCjgLIxOqdlEaKv4jL3bTJCTOf+li2+hEujvSsj9oi/9jq/5W9+o8jXJPp5+3hCZ0B/zSnMAoo7pQusHUpa9AcQYJZrR3kmw+XbhtrWR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781554786; c=relaxed/simple;
	bh=PSFbqizfoRxpJ9SdU+0UN+tMF2SLn8/ZW6Ggy3kS+BU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p6QNtPLUQvSbdKTKgekf+CZYQlG2dwvDHJvSqgtcYi3jmjjKHZQ8ExWiqGdBl6DsRsUZUE6NC19acu2WKmB5JpyAVLR/XD0jSIh51vFoX05ifW7C9DUX0smHwT+cIkkaUkdPSSMUeJTgYlL18ey79IyfVOvwiyqtWnwgRT9iF14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BiQuj6Dv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BiQuj6Dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFC01F000E9;
	Mon, 15 Jun 2026 20:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781554784;
	bh=q9MtdCSaQUNmO7ygTuBXbUVOYf/HCJOuBSr7sxavmtM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BiQuj6Dvoozrwg3X2ukypnOhYEsBs8qPQw3JN8gstHioPz9qirRjLKLWBQALzIZvj
	 YBDYf3kJKBzBHrZg3TCowO10NyMz1knfrFv0+aAwvfv8+csrJuRAmz/LvUKR5zCBeI
	 AA8diOPiv/K0CY7wKuBrTsWoIOM62WKq3Al0Cuk+d/hQEBO7cNy96zVaJrHH51vG4q
	 eZFjEDYz9E9ZIzDP9Sia8bQRN9xYuuhYAFkC4J1/fmVVAVqUSpCPveAfe67k9c/h1V
	 ygIukuVXpCVb9LXpnEuHZbfFf2w0fgo53EjIj1fgZbMe20hkeOqfOPFQvP+DWMK6Sg
	 ukwjjOKqvU+tw==
Message-ID: <ea71a433-fdcc-429d-adce-14e9fb726957@kernel.org>
Date: Mon, 15 Jun 2026 22:19:40 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/19] x86: define DPS root partition type UUIDs
To: Dave Hansen <dave.hansen@intel.com>, Jens Axboe <axboe@kernel.dk>,
 Davidlohr Bueso <dave@stgolabs.net>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org
References: <20260615-discoverable-root_partitions-v1-0-39c78fac42e2@kernel.org>
 <20260615-discoverable-root_partitions-v1-12-39c78fac42e2@kernel.org>
 <03be57ae-0e41-4b8a-adc5-bdd85ccce951@intel.com>
From: Vincent Mailhol <mailhol@kernel.org>
Content-Language: en-US
Autocrypt: addr=mailhol@kernel.org; keydata=
 xjMEZluomRYJKwYBBAHaRw8BAQdAf+/PnQvy9LCWNSJLbhc+AOUsR2cNVonvxhDk/KcW7FvN
 JFZpbmNlbnQgTWFpbGhvbCA8bWFpbGhvbEBrZXJuZWwub3JnPsKZBBMWCgBBFiEE7Y9wBXTm
 fyDldOjiq1/riG27mcIFAmdfB/kCGwMFCQp/CJcFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcC
 F4AACgkQq1/riG27mcKBHgEAygbvORJOfMHGlq5lQhZkDnaUXbpZhxirxkAHwTypHr4A/joI
 2wLjgTCm5I2Z3zB8hqJu+OeFPXZFWGTuk0e2wT4JzjgEZx4y8xIKKwYBBAGXVQEFAQEHQJrb
 YZzu0JG5w8gxE6EtQe6LmxKMqP6EyR33sA+BR9pLAwEIB8J+BBgWCgAmFiEE7Y9wBXTmfyDl
 dOjiq1/riG27mcIFAmceMvMCGwwFCQPCZwAACgkQq1/riG27mcJU7QEA+LmpFhfQ1aij/L8V
 zsZwr/S44HCzcz5+jkxnVVQ5LZ4BANOCpYEY+CYrld5XZvM8h2EntNnzxHHuhjfDOQ3MAkEK
In-Reply-To: <03be57ae-0e41-4b8a-adc5-bdd85ccce951@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/06/2026 at 18:46, Dave Hansen wrote:
> On 6/15/26 09:09, Vincent Mailhol wrote:
>> +#ifdef CONFIG_X86_64
>> +#define DPS_ROOT_PARTITION_TYPE_UUID "4f68bce3-e8cd-4db1-96e7-fbcaf984b709"
>> +#else
>> +#define DPS_ROOT_PARTITION_TYPE_UUID "44479540-f297-41b2-9af7-d131d5f0458a"
>> +#endif
> 
> This doesn't make a whole lot of sense to me. 64-bit kernels can run
> 32-bit userspace just fine.
> 
> But this #ifdef as proposed means that only a 32-bit *OR* 64-bit kernel
> can auto-discover a given partition.
> 
> I kinda think you should just have an array of strings for these things,
> maybe glued together with some preprocessor magic. Logically something
> like this:
> 
> const char* const uuids[] = {
> #ifdef CONFIG_ARM64
> 	"b921b045-1df0-41c3-af44-4c6f280d3fae"
> #endif
> #ifdef CONFIG_X86_64
> 	"4f68bce3-e8cd-4db1-96e7-fbcaf984b709",
> #endif
> #if defined(CONFIG_X86) && defined(CONFIG_COMPAT32)
> 	"44479540-f297-41b2-9af7-d131d5f0458a",
> #endif
> ...
> };
> 
> ... and then search the array. I honestly don't think you need to
> sprinkle UUIDs all over the architectures.
> 
> It could probably also be done almost entirely in Kconfig. This could be
> in, say block/partitions/Kconfig, or arch/*/Kconfig:
> 
> config DPS_ROOT_PARTITION_TYPE_UUID_1
> 	string
>         default "4f68bce3-e8cd-4db1-96e7-fbcaf984b709" if X86_64
> 	default "b921b045-1df0-41c3-af44-4c6f280d3fae" if ARM64
> 	...
> 
> config DPS_ROOT_PARTITION_TYPE_UUID_2
> 	string
>         default "44479540-f297-41b2-9af7-..." if X86 && COMPAT_32
> 
> const char* const uuids[] = {
> #ifdef CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_1
> 	CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_1
> #endif
> #ifdef CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_2
> 	CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_2
> #endif
> ...
> };
> 
> There are a lot of ways to do this. I'm just not a super big fan of the
> current proposal.
> 
> So, boiling it down:
> 
> 1. Should more than one UUID be supported per kernel build?

I didn't pay much attention to this, but this is a very good point.

The Discoverable Partitions Specification is not clear about this
point. All it has to say is:

  On systems *with matching architecture*, the first partition with
  this type UUID on the disk containing the active EFI ESP is
  automatically mounted to the root directory /.

Does an x86_32 system match an x86_64 partition? Wouldn't make sense.
Does an x86_64 system match an x86_32 partition? Could be.

My feeling is that the intent was an *exact* match. This is supported
by the implementation in systemd which just check against
SD_GPT_ROOT_NATIVE (which corresponds to the exact match).

  https://github.com/systemd/systemd/blob/main/src/udev/udev-builtin-blkid.c#L243-L247

*But* there are some hints about a secondary UUID. In my terminal I have:

  $ systemd-id128 show root root-secondary
  NAME           ID                              
  root           4f68bce3e8cd4db196e7fbcaf984b709
  root-secondary 44479540f29741b29af7d131d5f0458a

where root is the x86_64 and root-secondary is x86_32. So although I
see no match logic in the code, the ID table have it!

That said, your points make sense to me, and I would be supportive to
allow a search for a secondary UUID as a kernel extension. If we do
so, I think the only constraint should be to make sure that we check
for the exact match first (e.g. check x86_64 type before x86_32 type).

Would that make sense?

> 2. Should the UUIDs be defined in arch code or generic code?

I think that you convinced me to put it in generic code.

> 3. Kconfig or #ifdefs?

I would say Kconfig. If we go for the exact match only, that would be:

  CONFIG_DPS_ROOT_PARTITION_TYPE_UUID

If we allow more as an extension, that would become:

  - CONFIG_DPS_ROOT_PARTITION_TYPE_UUID for the exact match
  - CONFIG_DPS_ROOT_PARTITION_TYPE_UUID_SECONDARY for the compatible
    one.

The drawback is that some entries will be in both:

  config DPS_ROOT_PARTITION_TYPE_UUID
  	string
  	  default "4f68bce3-e8cd-4db1-96e7-fbcaf984b709" if X86_64
  	  default "44479540-f297-41b2-9af7-d131d5f0458a" if X86

  config DPS_ROOT_PARTITION_TYPE_UUID_SECONDARY
  	string
  	  default "44479540-f297-41b2-9af7-d131d5f0458a" if X86_64 && COMPAT_32

And I don't think we need more than two.


A bonus question: should those Kconfig entries be hidden? I prefer the
hidden option because it doesn't add that much code and I thought this
was not worth bothering the user with one more menuconfig question.
But I would be happy to change if people this this is worth an
menuconfig entry.


Yours sincerely,
Vincent Mailhol
