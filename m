Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795630965;
	b=ddAP9G2DTFT4ePILKeH+LEAoOqwxf9JjTOt7ccoygxO7mnXRHMs+8N4v2bhuV54wzR22
	 u3G/3ooVWThboMEwxHjLwW5YMEBWw5q8fpE1nT2ISbhgpauQFEnIfcWE6LSTSyXBQJC4P
	 RTuHhnTMybE8LPEJU6xVYWrHmEjAwA9X78gbPxgOLmLeJyYR/o729hVFeL1Ymt+dGWqfT
	 a9bsuK+7GGeBW/Zdessn1byWi8Lv3pWA8ikR9rwnlMgsIIMtNIWXnJiz8yuxlB4tbf1pO
	 Q0P5YR4WUrkvcIYhfNO91kmj0PeMUhqVDfntKosJRUcyTn58xD7emwmv7LukYYbjB+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795630965;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Rspamd-Server:X-Rspamd-Queue-Id:
	 X-Stat-Signature:X-Spam-Status:X-Session-Marker:X-Session-ID:
	 DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=6qR++cFUSbUPUEmO+yBbsbTsqe4WGzx7vfqPrLzKD+Y=;
	b=3ZKVcBTpNC6/JCS6uJ032o5JNcQV8NVAJio/uXSh5uFmmtIo/5fXFpfWAGpBy/sQUZIB
	 +X9ycRAob22E+JGQMyJq+My+kAj773MQmwh47aihpPB8izt7ZXwRCTPAjbGcf+qg5tbnL
	 jOf5jn70aEaWpHiiwbB6K1k6TcW8cHNug8MrurE1+xIm+Zy53kkMhd+Rdwk7ookJ7mH6D
	 86WaXlJ+8IctuWDdwV0v5OoxTYwdWEMaY4uqv8V+UMqCmkdDJDKM0XvVtMFJWkAeIuysu
	 xaAYiljwddDJasrjNLxMPEYqcn6mfIt09CmbK0puRUAz7ogOJ0Vo0Jci9tLc52oLi7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=dhj3qKPr;
	arc=none smtp.remote-ip=216.40.44.11
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3541D606A33C;
	Wed, 25 Nov 2026 18:22:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3541D606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=dhj3qKPr
Received: from omf19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C90DE120F71;
	Wed, 25 Nov 2026 18:22:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 2158E20028;
	Wed, 25 Nov 2026 18:22:27 +0000 (UTC)
Date: Wed, 25 Nov 2026 13:22:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Gary Guo" <gary@garyguo.net>
Cc: "Ian Rogers" <irogers@google.com>, <linux-kernel@vger.kernel.org>,
 <linux-trace-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
 <jpoimboe@kernel.org>, <peterz@infradead.org>, <mingo@redhat.com>,
 <tglx@kernel.org>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
 <x86@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
 <mark.rutland@arm.com>, <linux-arm-kernel@lists.infradead.org>,
 <pjw@kernel.org>, <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
 <alex@ghiti.fr>, <linux-riscv@lists.infradead.org>, <acme@kernel.org>,
 <namhyung@kernel.org>, <linux-perf-users@vger.kernel.org>,
 <mhiramat@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
 <andrii@kernel.org>, <bpf@vger.kernel.org>, <nathan@kernel.org>,
 <llvm@lists.linux.dev>, <nsc@kernel.org>, <linux-kbuild@vger.kernel.org>,
 <ojeda@kernel.org>, <rust-for-linux@vger.kernel.org>, <ardb@kernel.org>,
 <linux-efi@vger.kernel.org>, <maz@kernel.org>, <oupton@kernel.org>,
 <kvmarm@lists.linux.dev>, <shuah@kernel.org>,
 <linux-kselftest@vger.kernel.org>, <indu.bhagat@oracle.com>,
 <jremus@linux.ibm.com>, <wnliu@google.com>, <dylanbhatch@google.com>
Subject: Re: [RFC PATCH v2 00/30] unwind: Minimal DWARF CFI unwinding for
 user and kernel space
Message-ID: <20261125132225.00254c37@gandalf.local.home>
In-Reply-To: <DN4FM3TBOJ9T.2QOOL77P5HETO@garyguo.net>
References: <20261125061523.1540234-1-irogers@google.com>
	<DN4FM3TBOJ9T.2QOOL77P5HETO@garyguo.net>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: 2158E20028
X-Stat-Signature: bmxmyx7zbff3tj5wzgboeoe9y8ngdg7c
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/Cm47ggEMe5tkUQwuPIv9j4yoOc3+2FwI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=6qR++cFUSbUPUEmO+yBbsbTsqe4WGzx7vfqPrLzKD+Y=; b=dhj3qKPrnd5Ol5oStgJ72xjormeA1wf1DO/RZc9kjGarZplof6LxOCEYEKKVU+6U05bo+jnrn30dh3AQ2S2utOXzBrNDvJP6ChCp0OiNHXA0Mz5Qca51KujLnC0+gny5rgFtqYDHuEEGrRoB4ayAc52wJ7NqKJRyFXoq+87Y6Bg=
X-HE-Tag: 1795630947-362156
X-HE-Meta: U2FsdGVkX18ShW9pI+/3LezhiP+sfLyAz5bbFmDR0Cg79ArNrSxS4kGp2fzzjf2A8iMOExZ79Wjpfg5dnD2BuvcnWnPjmIUJbGqbBkLfSiaYUFYSqR7ZAyP5O5UzEvRDCN589rXn1aP6/jRut7zfB+DDsEhPmN5DqCQvkQ7ZfZK1DiZPYS6+dvk+POli+n6GtTpGQ+j2vtl3LmQVHr+SzbA0nhYCBgifjijh6DwBsiIDVGFv0Nn3Ybo7aD+vHLlpczM4CVbNSwTPAeoiNfZ1pIRQfuRQQygtba8VmRY7xWxfdUk9RhDQhUICoUNpPyMEpj3E7lFTHILx587J1If+CzVdP12M+SkIwx9akUq8SAeuSlUzaZ2IKhNYhFH5nvIw0f5ED6Ry586F6FXLp5r+/Q==

On Wed, 25 Nov 2026 16:28:02 +0000
"Gary Guo" <gary@garyguo.net> wrote:

> A quick question: how do you plan to get this working on 32-bit ARM which has
> its own EHABI?

Do we care? Isn't ARM 32 mostly deprecated at this moment? Or at least not
adding new features.

-- Steve
