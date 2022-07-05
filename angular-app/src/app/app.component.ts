import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
})
export class AppComponent implements OnInit {
  title = 'angular-app';
  data = 'Loading...';
  backendHost = '/api';

  constructor(private http: HttpClient) {}

  ngOnInit() {
    this.http
      .get<any>(this.backendHost + '/data')
      .subscribe((data: any) => {
        this.data = data;
      });
  }
}
