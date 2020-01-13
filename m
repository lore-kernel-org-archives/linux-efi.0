Return-Path: <SRS0=ETnK=3C=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91CC8C33CA9
	for <linux-efi@archiver.kernel.org>; Mon, 13 Jan 2020 15:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6472E207FD
	for <linux-efi@archiver.kernel.org>; Mon, 13 Jan 2020 15:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578930609;
	bh=frgfejC4oQgem8zcK/51ieHqwWzLYAGllVuLGW/ZL5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=POlSukGR5OAxlbW1FHq4Dw2hG50JzWgO2hN3lFE1UWsZVKfQL+n76inYySUlc6/SA
	 4hxkf9hnZYyGWer63v9P2B9NtgwWRHvkB/0bmceMe5X+b9x5h5nQJqFVaFjliB2uRi
	 TeRBNkf+CYujhbG5MVlf5Dj8KfNF/d4/XVNFQIjE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgAMPuJ (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 13 Jan 2020 10:50:09 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36476 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgAMPuJ (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 13 Jan 2020 10:50:09 -0500
Received: by mail-yw1-f67.google.com with SMTP id n184so6374978ywc.3;
        Mon, 13 Jan 2020 07:50:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P7zkiitkCWsuSRKPmAwAK7CcYVjDngYZSCq21E01NRk=;
        b=rmvepy1x5AqgPVLurPEniloBeaJ0Q1QKeRGpndF2ifpZQ73OV3EUZb0epbw0BBJ0zD
         6VYKXQLrmKZYG2hvhBAnCXwpeh0ACOS6xMK1CBrrM0vMNmCjUNPYMXKm1KCnNpcws1NQ
         KvEXhdUJiaUaV4f5m+k9ItmFETt0cyh6Luk62RVyjB/kFubHj4PW4yVn4vcwWIa4PbiS
         pLbeB+OzgVXUfDJXXoU3sDG2p0fo4FiVQWhK2bemBaAiRaJcNqBUjQ6gePRAz6Z+gI1p
         KKJd+59/7v9VNyqb7r3Bx6irnyvx2fwkvGq1I6NafL4DrFuw5t8C/D9frxzpWklGoUhW
         RvHQ==
X-Gm-Message-State: APjAAAVjB+okExrPtoMz3lKoGEK9TnSwHkWOOWW9ZMUVu/8iSH9yspYl
        tMzH7D24xuif6c0J9ejzUrA=
X-Google-Smtp-Source: APXvYqwysToLWulQEKKQYs42+APLU16g4SfL5vezVQaE09a4FXcdkrOwmGA1950TxEodJ/XryowyeA==
X-Received: by 2002:a0d:e697:: with SMTP id p145mr13360006ywe.199.1578930607860;
        Mon, 13 Jan 2020 07:50:07 -0800 (PST)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 144sm5172420ywy.20.2020.01.13.07.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 07:50:07 -0800 (PST)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 1E9EB4018C; Mon, 13 Jan 2020 15:50:06 +0000 (UTC)
Date:   Mon, 13 Jan 2020 15:50:06 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Jones <pjones@redhat.com>,
        Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v11 05/10] test_firmware: add support for
 firmware_request_platform
Message-ID: <20200113155006.GC11244@42.do-not-panic.com>
References: <20200111145703.533809-1-hdegoede@redhat.com>
 <20200111145703.533809-6-hdegoede@redhat.com>
 <20200113145328.GA11244@42.do-not-panic.com>
 <54f70265-265b-ad23-7d2d-af0b27ab1475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54f70265-265b-ad23-7d2d-af0b27ab1475@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Mon, Jan 13, 2020 at 04:22:36PM +0100, Hans de Goede wrote:
> 
> test_firmware and dropping the mutex calls is better. I will make
> this change for v12 of this series.
> 
> I'll send out a v12 once the remarks from Andy Lutomirski's
> have also been discussed.

Sure, just think twice about loosing the ability to access the
test_firmware pointer from userspace. If you can find value
in extending your tests then keep it, otherwise if its just
to do the actual test in C in the call itself, it makes sense
to avoid it for that test case.

  Luis
