Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792754807;
	b=zRmdq/f1aACNPKvQCoc946jiWCPKzq3zJOltdwgD9lQ7QdIv3gbc0J1mWwMpJNPNwfzf
	 qHljUdvrL//5yJGk0FwyevaadzUeBa16PZ+JlUCq9VT7c/fYnj/bpZEaBclFby4ZqOOGR
	 2CDd/9PiC9CIz2Mo1Xqf7hLS9EWPLYbBcPFK6qz2AvdBaGj7Aqn9Rm5o32t/8ZA0ALik3
	 toTZZh/ko2mKqpYPUMWBBilEdTLahlyoTSxodK2DDb2RnWc+bonkmEIqNUBfmRwYEHFvE
	 74XjE2hq9Vm+N867fFDpy6bfohmpnXu/VxRFl/U40ESo/p5btPfRwNgBwe26Hn+aQYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792754807;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=rH5uI+MFFbqA2/IjxVKao6Wy3U0y7FtYS68LxQh8NN0=;
	b=yfAOioq68RLaedmJUeGTfR7BLdZ0J8xLtdZLOvhUElU1KHEgkkyA+rixe3n3EBd5aEMa
	 Ha122cRZ1U39+1dk3j4YPm4ZlObVrFmwqOIulxnZfMWNZVOnINzj+19Ka0MjBwDMYIo9Y
	 6G5C0Wy6WFLBMWlr4jri455Da46RZ6He35m9AlFiGVfPR5F+TlDA9OLsjS+qwuvYHkceV
	 JObUa8NLOm2aL6yt6OISM2+HW3DowRVAG9zz2JgUPbkUMLoAjN3op8YVGOdoPcFWXyjnM
	 qZVYSpoOam3vCf1yoO17ldEUp9GCNuOj2BhBJR7XO/G+rHyL6TtMOfRXFSooREgACfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=g09d70JU;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vEPP7UqY;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=g09d70JU;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vEPP7UqY;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD7E606A31A;
	Fri, 23 Oct 2026 11:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFD7E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=g09d70JU;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vEPP7UqY;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=g09d70JU;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vEPP7UqY
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9EB9A1F785;
	Fri, 23 Oct 2026 11:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792754797; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rH5uI+MFFbqA2/IjxVKao6Wy3U0y7FtYS68LxQh8NN0=;
	b=g09d70JUhHy1R/ylgiL3xD+c9XkLyM5XAWeqxDoj1gStW+S5GjCU8Q5KFfjYlrfxNKPEgk
	uFs1oDSwW1WGkxDxQ8GboLF6dbApD8iC6gcM5PEME2N3dV2o2Jnww/orlLuYxb961M/okl
	FLeIz44ht8n6Vxw103z7dyG66eZSNt0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792754797;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rH5uI+MFFbqA2/IjxVKao6Wy3U0y7FtYS68LxQh8NN0=;
	b=vEPP7UqYltxaqK7Xukyvllo+6SuslGec4MxGptvGWpg6yC0jhGmCBCf0yEKiFBpEpYCHiS
	O7X0CFUDlZ3kPKAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=g09d70JU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vEPP7UqY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792754797; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rH5uI+MFFbqA2/IjxVKao6Wy3U0y7FtYS68LxQh8NN0=;
	b=g09d70JUhHy1R/ylgiL3xD+c9XkLyM5XAWeqxDoj1gStW+S5GjCU8Q5KFfjYlrfxNKPEgk
	uFs1oDSwW1WGkxDxQ8GboLF6dbApD8iC6gcM5PEME2N3dV2o2Jnww/orlLuYxb961M/okl
	FLeIz44ht8n6Vxw103z7dyG66eZSNt0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792754797;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rH5uI+MFFbqA2/IjxVKao6Wy3U0y7FtYS68LxQh8NN0=;
	b=vEPP7UqYltxaqK7Xukyvllo+6SuslGec4MxGptvGWpg6yC0jhGmCBCf0yEKiFBpEpYCHiS
	O7X0CFUDlZ3kPKAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D68AF133F6;
	Fri, 23 Oct 2026 11:26:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2mW1KmxE22r7RQAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 23 Oct 2026 11:26:36 +0000
Message-ID: <645c1c2b-9aa8-44b4-8a67-dcd7bfbe8fbd@suse.de>
Date: Fri, 23 Oct 2026 13:26:36 +0200
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
Subject: Re: [PATCH v5 03/13] drm: client: add splash client
To: =?UTF-8?Q?M=C3=A0xim_Pedraza_Padilla?= <maximpedraza@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Francesco Valla <francesco@valla.it>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Mario Limonciello <mario.limonciello@amd.com>,
 Javier Martinez Canillas <javierm@redhat.com>,
 Jocelyn Falempe <jfalempe@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org,
 devicetree@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-embedded@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261013093243.505776-1-maximpedraza@gmail.com>
 <20261013093243.505776-4-maximpedraza@gmail.com>
 <fafa7327-e624-49f2-98b2-83fd602a0ad7@suse.de>
 <20261021005006.2341200-2-maximpedraza@gmail.com>
Content-Language: en-US
From: Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 xsBNBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAHNJ1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPsLAjgQTAQgAOAIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftODH
 AAoJEGgNwR1TC3ojx1wH/0hKGWugiqDgLNXLRD/4TfHBEKmxIrmfu9Z5t7vwUKfwhFL6hqvo
 lXPJJKQpQ2z8+X2vZm/slsLn7J1yjrOsoJhKABDi+3QWWSGkaGwRJAdPVVyJMfJRNNNIKwVb
 U6B1BkX2XDKDGffF4TxlOpSQzdtNI/9gleOoUA8+jy8knnDYzjBNOZqLG2FuTdicBXblz0Mf
 vg41gd9kCwYXDnD91rJU8tzylXv03E75NCaTxTM+FBXPmsAVYQ4GYhhgFt8S2UWMoaaABLDe
 7l5FdnLdDEcbmd8uLU2CaG4W2cLrUaI4jz2XbkcPQkqTQ3EB67hYkjiEE6Zy3ggOitiQGcqp
 j//OwE0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRHUE9eosYb
 T6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgTRjP+qbU6
 3Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+RdhgATnWW
 GKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zbehDda8lv
 hFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r12+lqdsA
 EQEAAcLAdgQYAQgAIAIbDBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftOH6AAoJEGgNwR1T
 C3ojVSkIALpAPkIJPQoURPb1VWjh34l0HlglmYHvZszJWTXYwavHR8+k6Baa6H7ufXNQtThR
 yIxJrQLW6rV5lm7TjhffEhxVCn37+cg0zZ3j7zIsSS0rx/aMwi6VhFJA5hfn3T0TtrijKP4A
 SAQO9xD1Zk9/61JWk8OysuIh7MXkl0fxbRKWE93XeQBhIJHQfnc+YBLprdnxR446Sh8Wn/2D
 Ya8cavuWf2zrB6cZurs048xe0UbSW5AOSo4V9M0jzYI4nZqTmPxYyXbm30Kvmz0rYVRaitYJ
 4kyYYMhuULvrJDMjZRvaNe52tkKAvMevcGdt38H4KSVXAylqyQOW5zvPc4/sq9c=
In-Reply-To: <20261021005006.2341200-2-maximpedraza@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-12.00 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[25];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[linux.intel.com,kernel.org,gmail.com,ffwll.ch,lwn.net,valla.it,amd.com,redhat.com,ravnborg.org,linaro.org,linuxfoundation.org,infradead.org,lists.freedesktop.org,vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[dt];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.00
X-Spam-Level: 
X-Rspamd-Queue-Id: 9EB9A1F785

Hi

Am 21.10.26 um 02:50 schrieb Màxim Pedraza Padilla:
> Hi Thomas,
>
> Thanks a lot for the thorough review. I was preparing v6 when it came
> in; I will hold it back and work all of this in first. Answers below.
>
> Am 20.10.26 um 12:28 schrieb Thomas Zimmermann:
>> This lengthy comment should be a list of per-revision changes, like this:
>>
>> v5:
>> - exit when firmware BMP is missing
>> - foo
>> - bla
>>
>> and so on. We keep these in the commit message right before the tags.
> Will do.
>
>>> +	select DRM_CLIENT_LIB if DRM_CLIENT_SPLASH
>>>    	select DRM_CLIENT_LIB if DRM_CLIENT_LOG
>> Alphabetic order please
> OK.
>
>>> +	  The color can be overridden through the drm_client_lib.splash_color
>>> +	  kernel command line parameter.
>> No extra module parameters please.
> [...]
>
>> As I said, no module parameter for colors.  The color is something that
>> the SoC firmware vendor would know at build-time. There is no reason for
>> the user to modify this at runtime.
> Sorry, I should have answered this the first time rather than keep
> the parameter without a word. Let me explain why I would like to keep
> the command line, for the colour and also for the parameters patch 12
> adds, and you tell me whether it holds.
>
> The build-time defaults cover what a product normally shows. The
> parameters are for what is only known at boot: the bootloader finds an
> update pending, a failed boot count or a recovery request, or reads the
> product variant from an EEPROM, and wants the splash to say so, with
> another logo or a red or amber background. Any bootloader can do that
> by adding to the command line: a setenv in a U-Boot script, a recovery
> entry in GRUB or systemd-boot. Changing the device tree instead needs
> fdt support in the bootloader and knowledge of the node, and is not
> possible at all when the device tree is signed along with the kernel
> in a FIT image. On x86 with the BGRT there is no device tree, and the
> command line is the only way.

I'd just like to say that these are not good uses of the splash screen.  
They also move the goal from having a boot-up logo to 
reporting/debugging boot-up problems.

>
> There is precedent for this kind of setting: video=...,rotate=,
> fbcon=rotate: and fbcon=logo-pos: are all about how the boot screen
> looks, and console= wins over stdout-path the way these win over the
> device tree.

video= has its uses, but the others seem misguided. Rotation should be 
auto-configured in some way; logo-pos shouldn't even be a thing IMHO.


>
> So my proposal for v6: the defaults are set at build time, as you ask
> (the colour already is, and the BMP's file name becomes a Kconfig
> string), and the parameters stay, only to override them for one boot.
> If that is still a no, I will drop them all, patch 12 included.

Please drop the parameters for now. If we want to give status messages 
from boot loader to kernel, we should first evaluate how to do that 
correctly. This involves people from the various supported 
architectures. Once we have support for such a channel, we can try to 
use it on any DRM client and build a shared solution.

I'm not against reporting boot-loader messages, but it seems to require 
a lot more thought that what can be done here in this series.


>
>> How could we find out about the bmp's file name? I assume it is just a
>> file in the initfs, which we have to know about?
> It is requested with request_firmware_nowait(), so it is looked up like
> any other firmware: built into the kernel with EXTRA_FIRMWARE, in the
> initramfs, or under /lib/firmware once the root file system is there.
> The name is fixed by whoever builds the image, so
>
>> In any case, this should again not be module parameter. Please make it
>> build-time configurable via Kconfig.
> a Kconfig string fits it well for the default name; v6 will have it.
> splash_bmp= would then only pick another file for one boot, such as
> one of several images built in with EXTRA_FIRMWARE, as above.
>
>>> +} __packed;
>> These types are already in efifb.c can we move them into a header file.
>> include/video/bmp.h should work.
> Yes, I'll add a patch that moves them there and makes efifb use the
> header. The header keeps the __le types, as BMP is little endian
> whatever the CPU, so efifb will read the fields through
> get_unaligned_le*() like the splash does; no change on the little
> endian systems EFI runs on. That patch touches fbdev, so it will go to
> Helge and Peter as well.

Makes sense.

>
>>> +	*data = fw->data;
>>> +	*size = fw->size;
>> Why does this work?
>>
>> We no longer hold a lock on fw. If a concurrent thread calls
>> release_firmware() on splash->fw, data and size might become invalid.
> The only release_firmware() on splash->fw is in
> drm_splash_image_cleanup(), which runs in the render thread itself
> once it has drawn, and at unregister after the thread has been
> stopped. The firmware callback stores the firmware under fw_lock, or
> releases it itself if the thread is already done, and never touches it
> again. So nobody can release it while the thread reads from it; the
> lock is only there for the hand-over from the callback. I'll put that
> in a comment, since it is not obvious from the code.

Thanks.

>
>>> +	drm_info(client->dev, "splash: request %s as firmware", splash_bmp);
>> drm_dbg() here. drm_info() is log spam.
> OK, here and in the other places you pointed out.
>
>>> +	int i;
>> format_count is an unsigned int. i should lik
> OK.


Oh, I just noticed that my comment got truncated. I meant to that "i 
should likely by unsigned int as well".


>
>> Values like px_width are deprecated because they don't work in the
>> general case.  Rather pass the format as drm_format_into and do the
>> px_width lookup within the drm_splash_fill().
> OK.

At some point I'd like to have a nice, shared drawing interface that all 
the clients can use easily.


>
>>> +			scolor = *(const u32 *)(&sbuf8[src_offset + 3 * x]);
>> Please build scolor from the individual entries in the color table. This
>> type casting is fragile. It also only works on little endian with
>> unaligned loads AFAIU.
> Agreed. It also read one byte past the end of the image on the last
> pixel. v6 already reads each pixel with get_unaligned_le24(), which
> builds it from the three bytes, in this patch rather than in a later
> one as in v5.
>
>>> +	bmp_width = (s32)get_unaligned_le32(&dib_header->width);
>>> +	bmp_height = (s32)get_unaligned_le32(&dib_header->height);
>> Why not make these variables unsigned?
> [...]
>
>>> +	bmp_invert_y = (bmp_height > 0);
>>> +	bmp_height = abs(bmp_height);
>> That's the answer to my question above, i guess?   But what about bmp_width?
> Yes. Both are signed in the BMP header, as in efifb's struct
> bmp_dib_header. A negative width has no meaning, and keeping it signed
> lets the format check reject it as such (bmp_width <= 0) rather than
> see a huge width that only the size checks further down would stop.
> I can read the width as unsigned and check it against S32_MAX instead
> if you prefer.

It's ok.

>
>>> +		 * On x86 some firmwares use a low non native resolution for
>> 'Some firmware on x86 uses a non-native resolution for'
>>
>>> +		 * the display when they have shown some text messages. While
>> 'the display if it has shown some text messages.'
> OK, thanks.
>
>> The entire if-else block below should be a function drm_splash_blit().
>> Please also see my comment on using px_width.
> OK. Together with your comment on patch 9, the blit will become a
> function from this patch on.
>
>> The client receives a hotplug whenever the attached display changes.
>> Returning here would likely break anything after the initial one.
>>
>> Best is to kill the rendering thread, rebuild the list of modesets and
>> reinit.
> Right, today an output plugged in later stays dark, and a restore puts
> back the modesets of the first hotplug. v6 will rebuild on every
> hotplug, keeping the image around so that an output plugged in later
> gets it too.

It's probably ok to address things in small steps. DRM's common client 
interfaces could be easier to use and getting it all right is fairly 
complicated, I think.

Best regards
Thomas


>
>> Why does it use a rendering threat?  Wouldn't it be much easier to
>> schedule a worker?  You can also try to put it on the power-efficient
>> work queue.
> The thread mostly waits: for the BMP firmware and for the next
> redraw. A work item queued from the hotplug and from the firmware
> callback covers both, and makes the start and stop paths simpler,
> which is where v3 had its use-after-frees. I'll move it to
> system_power_efficient_wq.
>
>> I don't think this is right. (?) If there's no fb, the restore should
>> disable the display. Just run the commit below.
> Fair enough. The early return was there because committing modesets
> that still had a mode but no framebuffer failed with -EINVAL and a
> WARN. v6 already clears the mode of an output that gets no buffer;
> I'll do the same when the buffers are freed, drop the early return,
> and let the commit turn the outputs off.
>
>>> +	mutex_destroy(&splash->hotplug_lock);
>> This line belongs into drm_splash_client_unregister(). The free callback
>> is only for free-ing the client instance.
> OK.
>
>>> +	drm_dbg(dev, "Unregistered with drm splash");
>> 'free', not 'unregister'
> OK.
>
> Best regards,
> Màxim

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstr. 146, 90461 Nürnberg, Germany, www.suse.com
GF: Stefan Gaiser, Jochen Jaser, Abhinav Puri, (HRB 36809, AG Nürnberg)


