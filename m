Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8F8198E
	for <linux-efi@vger.kernel.org>; Fri,  8 Dec 2023 07:40:19 -0800 (PST)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6d8647941eeso2968088a34.3
        for <linux-efi@vger.kernel.org>; Fri, 08 Dec 2023 07:40:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702050018; x=1702654818;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cWtiugmZ6LcQca8zeFLfrq6YxpjpLZLymePOCAzvu0Y=;
        b=VBTAQJjXq7mor3yHoUvpt6XyKsPw4E69MwSq4DzarQci1a1rzNJom32oHoPo6Mvly4
         N3ACl3v0BFMhrnr4dRH7hrf/F7GJykR9RebrLfy5ylMdCL2uHBaPu0M+8Dr53C80TNjA
         /fN8wd6AgU2n8Wz1fYlffyf48WwwDqzc260PIwXCquDripDTb4if8QpYkBWJQAEqN+Va
         Sbu8P0ZtLc9cEs1ydnKqiXZEEGERTSDt3NjXgbKRH1bFTPfJcAQiTdwWpRK1WWPB6UrH
         oHqachF2gT1RTngJdDjw3uLkmnJD4CvJNunlbSGBFX9ED2ebyax3IcFJy74zOrkWBhhS
         wPCg==
X-Gm-Message-State: AOJu0YzKGTFxsG/OBiWApugkkOX5x13mefOLpPUpP6V19n86YNZQvOt+
	/L0O1ePzmsq0LEyB1qbCeIU2WM9hSJ4HMmRj9ZY4qmCXMrX3
X-Google-Smtp-Source: AGHT+IH8rGk8g1hG+8plzvOjBagXtrOuADWbXztcg8D0CEOp/qSUwUarictuSwnhuFrh6nwj/2xf5eDzRPbi08zGmSbJLvBmYfc3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6830:4428:b0:6d9:e844:f3e with SMTP id
 q40-20020a056830442800b006d9e8440f3emr167109otv.1.1702050018397; Fri, 08 Dec
 2023 07:40:18 -0800 (PST)
Date: Fri, 08 Dec 2023 07:40:18 -0800
In-Reply-To: <CAMj1kXGdLTsDnvqb3pe--eW3p480kbDRfyydMCUOW1m-3Bf9cg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc9918060c0166e7@google.com>
Subject: Re: [syzbot] BUG: corrupted list in efivar_entry_remove
From: syzbot <syzbot+1902c359bfcaf39c46f2@syzkaller.appspotmail.com>
To: ardb@kernel.org
Cc: ardb@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nogikh@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> On Fri, 8 Dec 2023 at 16:38, Aleksandr Nogikh <nogikh@google.com> wrote:
>>
>> If a command spans over two lines, syzbot expects a colon.
>>
>> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git
>> efivarfs-list-corruption-fix
>>
>
> It is Gmail that is breaking the line here
>
>
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git:

"git://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git:" does not look like a valid git repo address.

> efivarfs-list-corruption-fix
