Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1B5408254
	for <linux-efi@vger.kernel.org>; Thu, 12 Mar 2026 23:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773359674; cv=none; b=E5LlPSEzKxBuxlTZD2qGgAzzHWny2rsE5r9X8LkRVZA0FoIO5ljOGaNObTzfLRoAaiayTuLD85JWEKZt39I/nKvLrt3yhaS7NlqiWLN8ociaZRXgX/yOI09RoPwFRYvsXfLVzhjyOMiCIWHP6c8iBBNumlKh2eTSGzKnNOTZoJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773359674; c=relaxed/simple;
	bh=wOUC16WI4/reo5GvoZO5ESmt8rfD7PE3++Xf9novjKE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iQngcdA4tSb7x4MjMD8KA/fM4BiRMCQSopkexlVw6NuyzRmd95PFH7/aN654zNPcU1mwZctcB0gdIS20QRx9BPNNSzsfPHnWVILvRJbOjFj5ceamnUO7xuo7zoi9pXvd2xqof5rYUrorc0LYVvyYt5a/7VGw/qpDqPx2ucm2jnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QGn1W1R9; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QGn1W1R9"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b976e181895so2861566b.1
        for <linux-efi@vger.kernel.org>; Thu, 12 Mar 2026 16:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1773359672; x=1773964472; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pkgvHL0resGmXTqRBi16uC1NxLEncxIx9i+VLjGIXAo=;
        b=QGn1W1R9Hij3Ef8nPfb5Gr/yofFFvmy2QqxNnRw3aWSLsiA99K0V8a36+FqIBsvSzX
         oIEzDHmUQn5yL0KDDRc6/FSXJsRVwWZIxa2am8ZGpvUcM0WWwmh+eNK8YOpyp0T/jZYV
         zr7DtAisdIywdSS1smsOgnXccgY4WYlqIMvWo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773359672; x=1773964472;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkgvHL0resGmXTqRBi16uC1NxLEncxIx9i+VLjGIXAo=;
        b=euA8V9uYqKlZ+efnpDvvp/Z+HF95f6fx7uvEgUM+B524Gs9zjfpl36JHDV56fZa8Cd
         emhCiSJ/RkJMtdtuPYuwufafOzFPsD+9l40A4n0n0f4IpCinGx99xLiAi46oIbxKvf6x
         mIACvP97+ILFlhO5ieic2pPZv4034Wy0hzdTpC56uNd/k4eTqQQOUA+f6ycNVfiI1g1Y
         CEEaanJ7P+A93EmDmhbGE7mrtmWZ/IT1Wm77863UP0V035PI6+NmkzJZcGcUwcLpSg+1
         dAiub9WwYkeLLwIMo3+rYVyCC+U0pJdcCOaHiBODQg8LHUF3rzASYWvNAq666EJ9gWIY
         AQeg==
X-Forwarded-Encrypted: i=1; AJvYcCUsQyLIcDyeOqDP4HjORJ+OuymLzD/AiAGzX54wRnM1CHeOOW8Z1W6G4TMbT9hef5Iev9RfkcBTzlU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJs+uS5RzfRa5UIugn7S+HY+lxZiXhjDFpQKeSfG6w2ZBksJRb
	cG97Zn0RLaes52LBk/46VhCOJmym6q3QjnAAOtb2MdkWEzP5q1fFghbiT9k44giyGaj1RqwTw/P
	1b8ttDyg=
X-Gm-Gg: ATEYQzxAjbb24b+OXMlq0NurUy8sIQ+tEI1IBPlj1HjU5leh+DkNrHS6k1DdcK18w8q
	igqFFaRLWz9XTR7+B8F4MuNiRD+39U1lFV+idtKgW2t4iQee5YIc3prdALqeLsg/1eiKch1lBzJ
	r/5wQConfw4rqagMy2KblG2hKAnOI31R2Bbh8mlWyMjrJCMhF1NyIZhfjmzeYVIXEtfXsEh5lEj
	9Ddek+BYh84pDhclHrxYLAPqPKb210feFzVwLNpfOOXtwZFvQq//ACOaiXktK9pqkR5nm5xo7If
	O5BCPUKgob+peNoO9bqhFuayaPrWakwFYPfIMluCZTQLzP62SQQtTKZxIdtX2WcHF7jnYGZ+FzU
	r8FrLuY4oWcjzyp0qPhEQlmcgBbCUQ+Etlw+Hbd6P8qJM5rP3QiuItCdFLOd/Ew+UW1ZrDolAR2
	a/3I0oae6baWA4jD6CuzsoXbahhtYx38ESohYzNFk747PAqEmz87PnNI+Vqo2JGLRVC/PP+wevB
	SJs4k0knH8=
X-Received: by 2002:a17:906:8307:b0:b97:3bbe:e43a with SMTP id a640c23a62f3a-b9764f7918fmr53259066b.1.1773359671583;
        Thu, 12 Mar 2026 16:54:31 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b976cdb299esm3269066b.44.2026.03.12.16.54.30
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 16:54:31 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b976e181895so2860066b.1
        for <linux-efi@vger.kernel.org>; Thu, 12 Mar 2026 16:54:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVnxoDjDfRItZJgIW7xbMzv4aZ9sXCBKJmlcNwmJF74UKJgR3W5IDnWppcNVqmBEE597GF4gqBIdsk=@vger.kernel.org
X-Received: by 2002:a17:907:c5c9:b0:b96:d802:8b41 with SMTP id
 a640c23a62f3a-b9764fd8722mr66207066b.15.1773359215961; Thu, 12 Mar 2026
 16:46:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312214330.3885211-1-neilb@ownmail.net>
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Mar 2026 16:46:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
X-Gm-Features: AaiRm503fTaccEgKNbxF9h_dDHM9fUsSr52XJuxzTwCI0G9L03uDq8g5di1zchk
Message-ID: <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
Subject: Re: [PATCH RFC 00/53] lift lookup out of exclive lock for dir ops
To: NeilBrown <neil@brown.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jeff Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Carlos Maiolino <cem@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Jan Harkes <jaharkes@cs.cmu.edu>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Steve French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, Tyler Hicks <code@tyhicks.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, coda@cs.cmu.edu, linux-mm@kvack.org, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	ecryptfs@vger.kernel.org, gfs2@lists.linux.dev, linux-um@lists.infradead.org, 
	linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Mar 2026 at 14:44, NeilBrown <neilb@ownmail.net> wrote:
>
> This patch set progresses my effort to improve concurrency of
> directory operations and specifically to allow concurrent updates
> in a given directory.

I only got about half the patches, but the ones I did get didn't raise
my hackles.

HOWEVER.

This is very much a "absolutely requires ACKs from Al" series. Al?

Also, because I only got about half the patches, and there's 53 of
them total, I'd really like to see a git branch for something like
this. It makes it easier to review for me, and I suspect it makes it
easier for some of the test robots too.

But again - this needs Al to look at it. Iirc he had some fundamental
concern with the last version - hopefully now fixed, but ...

                 Linus
